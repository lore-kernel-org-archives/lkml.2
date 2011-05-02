Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758280Ab1EBSrY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 14:47:24 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:45833 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756907Ab1EBSrW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 14:47:22 -0400
Subject: Re: [PATCH V3 2/8] Add a new zerocopy device flag
From: Shirley Ma <mashirle@us.ibm.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: David Miller <davem@davemloft.net>, Eric Dumazet <eric.dumazet@gmail.com>,
        Avi Kivity <avi@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
        netdev@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20110502104257.GA21625@redhat.com>
References: <1303328216.19336.18.camel@localhost.localdomain>
	 <1303328648.19336.24.camel@localhost.localdomain>
	 <20110502104257.GA21625@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 02 May 2011 11:47:08 -0700
Message-ID: <1304362028.20660.15.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-05-02 at 13:42 +0300, Michael S. Tsirkin wrote:
> This comment should specify what exactly is the promise the
> device makes by setting this flag. Specifically, the
> condition is that no skb fragments are used
> after the uinfo callback has been called.
> 
> The way it's implemented, it probably means the device
> should not use any of skb_clone, expand head etc.

Agree. Or maybe force a copy when device uses skb_clone, expand
head ...?

Thanks
Shirley

