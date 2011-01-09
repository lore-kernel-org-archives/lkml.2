Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751488Ab1AIJdX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jan 2011 04:33:23 -0500
Received: from mailrelay002.isp.belgacom.be ([195.238.6.175]:32946 "EHLO
	mailrelay002.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751000Ab1AIJdV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jan 2011 04:33:21 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEALgOKU1R8j+m/2dsb2JhbACkRXS6bg2FPwQ
Date: Sun, 9 Jan 2011 10:33:19 +0100
From: Wim Van Sebroeck <wim@iguana.be>
To: Mike Waychison <mikew@google.com>
Cc: linux-watchdog@vger.kernel.org, linux-kernel@vger.kernel.org,
        Priyanka Gupta <priyankag@google.com>
Subject: Re: [PATCH 1/2] watchdog: Add support for sp5100 chipset TCO
Message-ID: <20110109093319.GI3801@infomag.iguana.be>
References: <1288054685-29107-1-git-send-email-mikew@google.com> <AANLkTik=eNbQoGaDLS_-8kZLFojK9P1Ge0QAEFc_cPtG@mail.gmail.com> <20110107082355.GD3801@infomag.iguana.be> <AANLkTin_xvms=Md_F0Uj0X=Exj61-bPALwABGFMX27bu@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTin_xvms=Md_F0Uj0X=Exj61-bPALwABGFMX27bu@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mike,

> The cleanups above seem fine to me.  What did you mean by "Change
> reboot_notifier by a platform shutdown" though?  I see that you
> removed the reboot_notifier, which is fine for our purposes.  Was this
> a suggestion to have this stuff get called from platform code if
> needed?  Am I missing something?

The platform_driver struct has a shutdown operation which does the same
as the reboot_notifier. Since the code is smaller and since the binary is
smaller we prefer to use the shutdown operation. So I removed the
reboot_notifier and added the shutdown operation.

Kind regards,
Wim.

