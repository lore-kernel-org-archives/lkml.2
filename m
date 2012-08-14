Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755563Ab2HNJrN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 05:47:13 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:40805 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752873Ab2HNJrM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 05:47:12 -0400
X-SpamFilter-By: BOX Solutions SpamTrap 5.19 with qID q7E9kWC4007901, This message is released by code: ctaloc0852
Message-ID: <502A1E79.3060301@realsil.com.cn>
Date: Tue, 14 Aug 2012 17:46:33 +0800
From: wwang <wei_wang@realsil.com.cn>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "cjb@laptop.org" <cjb@laptop.org>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "bp@alien8.de" <bp@alien8.de>
Subject: Re: [PATCH 1/2] drivers/mfd: Add realtek pcie card reader driver
References: <1344922213-19581-1-git-send-email-wei_wang@realsil.com.cn> <201208140932.27276.arnd@arndb.de>
In-Reply-To: <201208140932.27276.arnd@arndb.de>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2012年08月14日 17:32, Arnd Bergmann 写道:
> When you post a new version of patches, please add a version number in the
> subject line, like " [PATCH v3 1/2] drivers/mfd: Add realtek pcie card
> reader driver", to make it easier for people to know what has changed.
> It's also helpful to have a "[PATCH 0/XX]" as 'git format-patch
> --cover-letter' generates and list the changes to the previous versions
> of your patch in there. Best combine this with 'git send-email --thread
> --no-chain-reply', so all patches are sent in the same email thread as
> the introductory mail.
>
> Finally, when you get an 'Acked-by' or 'Reviewed-by' tag from someone,
> please add that below your Signed-off-by.
>
> Your patches both look fine now, so you can add my
>
> Reviewed-by: Arnd Bergmann <arnd@arndb.de>
>
> 	Arnd

Hi Arnd:

OK. I will resend both of the patches according to your suggestion.

Thank you so much!

BR,
wwang
