Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760127Ab1LPQF3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 11:05:29 -0500
Received: from mail-ww0-f42.google.com ([74.125.82.42]:43380 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759429Ab1LPQFV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 11:05:21 -0500
MIME-Version: 1.0
In-Reply-To: <1324051285.25554.37.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
References: <1324012057.2562.23.camel@edumazet-laptop>
	<20111216155408.GA31770@google.com>
	<1324051285.25554.37.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Date: Fri, 16 Dec 2011 08:05:19 -0800
X-Google-Sender-Auth: POw3tMz-LnqbgemOmevYd6RmksE
Message-ID: <CAOS58YOJTaoB1xsJ4D56x1v+ZM5qsP3ojrJqsFAMJR2YUaHKxA@mail.gmail.com>
Subject: Re: [PATCH] module: struct module_ref should contains long fields
From: Tejun Heo <tj@kernel.org>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>, Robin Holt <holt@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, Dec 16, 2011 at 8:01 AM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> Its percpu data, there is no need to waste a full cache line per cpu for
> this.

Hmmm.... okay. I just don't like seeing arbitrary alignment there.
Can you please add some comment explaining why the unusual alignment
is used there?

Thanks.

-- 
tejun
