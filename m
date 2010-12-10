Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756585Ab0LJQ0C (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 11:26:02 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:57295 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756546Ab0LJQ0A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 11:26:00 -0500
Subject: Re: [RFC PATCH V2 5/5] Add TX zero copy in macvtap
From: Shirley Ma <mashirle@us.ibm.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Avi Kivity <avi@redhat.com>, Arnd Bergmann <arnd@arndb.de>, mst@redhat.com,
        xiaohui.xin@intel.com, netdev@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <1291976864.3580.7.camel@edumazet-laptop>
References: <1291976026.2167.49.camel@localhost.localdomain>
	 <1291976864.3580.7.camel@edumazet-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 10 Dec 2010 08:25:55 -0800
Message-ID: <1291998355.2167.53.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-12-10 at 11:27 +0100, Eric Dumazet wrote:
> You could make one atomic_add() outside of the loop, and factorize
> many
> things...
> 
> atomic_add(len, &skb->sk->sk_wmem_alloc);
> skb->data_len += len;
> skb->len += len;
> skb->truesize += len;
> while (len) {
>         ...
> } 

Yep, thanks, will update it!

Shirley

