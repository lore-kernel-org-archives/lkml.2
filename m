Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752223Ab2IHIIv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2012 04:08:51 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:51818 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751855Ab2IHIIo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2012 04:08:44 -0400
Date: Sat, 8 Sep 2012 01:06:09 -0700
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Marco Stornelli <marco.stornelli@gmail.com>
Cc: Bryan Freed <bfreed@chromium.org>, John Stultz <john.stultz@linaro.org>,
        linux-kernel@vger.kernel.org, keescook@chromium.org,
        sboyd@codeaurora.org, gregkh@linuxfoundation.org,
        Colin Cross <ccross@android.com>, Tony Luck <tony.luck@intel.com>,
        devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH v6] pstore/ram: Add ramoops support for the Flattened
 Device Tree.
Message-ID: <20120908080607.GA22071@lizard>
References: <1347042576-17675-1-git-send-email-bfreed@chromium.org>
 <20120908052907.GA4724@lizard>
 <504AF27C.9090601@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <504AF27C.9090601@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 08, 2012 at 09:23:40AM +0200, Marco Stornelli wrote: [...]
> >>+	pdata = devm_kzalloc(dev, sizeof(*pdata), GFP_KERNEL);
> >>+   if (pdata == NULL)
> >
> >I wonder why people prefer to not write !pdata, which is more natural
> >when reading the code.. :-)
> 
> I think it's the same for sizeof, it's much more readable
> sizeof(struct ramoops_platform_data).

Well, sizeof(struct...) is against Linux coding style.  And there are
good reasons for this rule, it's all in the CodingStyle file. Thus,
it's not about personal preferences. But speaking of personal
preferences, I don't find sizeof(struct...) more readable. :-)

Thanks!
Anton.
