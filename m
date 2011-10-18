Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756745Ab1JRIiO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 04:38:14 -0400
Received: from mailservice.tudelft.nl ([130.161.131.5]:55881 "EHLO
	mailservice.tudelft.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751062Ab1JRIiM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 04:38:12 -0400
X-Spam-Flag: NO
X-Spam-Score: -21.9
Message-ID: <4E9D3AEE.6070809@tremplin-utc.net>
Date: Tue, 18 Oct 2011 10:38:06 +0200
From: =?UTF-8?B?w4lyaWMgUGllbA==?= <Eric.Piel@tremplin-utc.net>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:7.0.1) Gecko/20111006 Thunderbird/7.0.1
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, alsa-devel@alsa-project.org,
        david.henningsson@canonical.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [REGRESSION] Sound goes too fast due to 798cb7e897210
References: <4E9D3466.5000901@tremplin-utc.net> <s5hzkgy1zf1.wl%tiwai@suse.de>
In-Reply-To: <s5hzkgy1zf1.wl%tiwai@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Op 18-10-11 10:23, Takashi Iwai schreef:
> At Tue, 18 Oct 2011 10:10:14 +0200,
> Éric Piel wrote:
:
> If that commit affects, the best fix would be to give a quirk specific
> to your device.  Try to pass either position_fix=1 or position_fix=2.
> Only one of them should work (likely 2).
>
> After checking it, you can add it to position_fix_list[] in
> sound/pci/hda/hda_intel.c together with PCI SSID.

Hello,
Thanks for the quick response. Indeed forcing position_fix=1 does fix 
the bug. I'll not try to make a patch for my device.

Cheers,
Éric
