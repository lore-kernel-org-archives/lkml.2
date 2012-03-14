Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030615Ab2CNCqb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 22:46:31 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:48277 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1030485Ab2CNCq2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 22:46:28 -0400
Message-ID: <1331693187.27389.33.camel@joe2Laptop>
Subject: Re: [PATCH] Staging: rtl8187se: r8180_core.c: Fix coding style issue
From: Joe Perches <joe@perches.com>
To: Andrew Miller <amiller@amilx.com>,
        Larry Finger <Larry.Finger@lwfinger.net>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Date: Tue, 13 Mar 2012 19:46:27 -0700
In-Reply-To: <20120314023342.GC7156@iron>
References: <1331686689-6763-1-git-send-email-amiller@amilx.com>
	 <1331688836.27389.13.camel@joe2Laptop> <20120314014949.GB7156@iron>
	 <1331691146.27389.20.camel@joe2Laptop> <20120314023342.GC7156@iron>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-03-13 at 22:33 -0400, Andrew Miller wrote:
> Thanks, you help me alot
> 
> If you don't mind me asking a few more question.
> 
> Would fixing things like this
> 
> - if(x==y)
> + if(x == y)
> 
> be worthless? 

I don't work on staging code.

I believe the staging rtl8187se directory could be
deleted as there is a working mainline directory
for the 8187 (drivers/net/wireless/rtl818x/rtl8187)
so you may not actually be adding anything of value.

I don't know if the 8187se is supported by the 8187
code but likely Larry Finger (cc'd) knows better.


