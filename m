Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753738Ab2DBR3b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 13:29:31 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:50300 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751553Ab2DBR3a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 13:29:30 -0400
Message-ID: <1333387768.20402.7.camel@joe2Laptop>
Subject: Re: CONFIG_RTLWIFI_DEBUG default y
From: Joe Perches <joe@perches.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Date: Mon, 02 Apr 2012 10:29:28 -0700
In-Reply-To: <20120402171733.GB13264@x1.osrc.amd.com>
References: <20120402164920.GA13264@x1.osrc.amd.com>
	 <1333385618.15422.17.camel@joe2Laptop>
	 <20120402171733.GB13264@x1.osrc.amd.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-04-02 at 19:17 +0200, Borislav Petkov wrote:
> On Mon, Apr 02, 2012 at 09:53:38AM -0700, Joe Perches wrote:
> > To keep all the "printk(KERN_DEBUG" to "pr_debug(" conversion
> > output the same as the it was prior to the patch.
> > 
> > Larry can default it to off if he wants.
> 
> >From looking at one user of this -
> drivers/net/wireless/rtlwifi/rtl8192ce/hw.c - some of the messages look
> like important ones which you wanna have enabled always, f.e. error
> handling in rtl92ce_hw_init().
> 
> It probably needs splitting into debugging messages which are default n
> and always-on messages.

>From my perspective, anything KERN_DEBUG that should always be
output should not be KERN_DEBUG but some other KERN_<LEVEL>.

