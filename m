Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759011Ab2IMW2t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 18:28:49 -0400
Received: from mail.skyhub.de ([78.46.96.112]:54003 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753865Ab2IMW2s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 18:28:48 -0400
Date: Fri, 14 Sep 2012 00:28:43 +0200
From: Borislav Petkov <bp@alien8.de>
To: Sid Boyce <sboyce@blueyonder.co.uk>
Cc: LKML Mailing List <linux-kernel@vger.kernel.org>,
        Andreas Herrmann <andreas.herrmann3@amd.com>
Subject: Re: AMD Bulldozer FX-8150 Powers off during kernel build
Message-ID: <20120913222843.GA24666@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Sid Boyce <sboyce@blueyonder.co.uk>,
	LKML Mailing List <linux-kernel@vger.kernel.org>,
	Andreas Herrmann <andreas.herrmann3@amd.com>
References: <50513733.8040801@blueyonder.co.uk>
 <20120913094413.GB15810@liondog.tnic>
 <50525719.5010701@blueyonder.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <50525719.5010701@blueyonder.co.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 13, 2012 at 10:58:49PM +0100, Sid Boyce wrote:
> If needed I can go back to the earlier 3.6.0-rc5 kernel and config to
> recreate the power off situation. With the kernel that powered off,
> MCE was not set and CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE=y

Yes, as I suggested earlier, enable CONFIG_X86_MCE and
CONFIG_EDAC_DECODE_MCE and *then* try recreating the reboot.

After it reboots, catch the whole dmesg and send it to me.

Thanks.

-- 
Regards/Gruss,
    Boris.
