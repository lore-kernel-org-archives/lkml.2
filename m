Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753823Ab3AHUIb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 15:08:31 -0500
Received: from mail.skyhub.de ([78.46.96.112]:34753 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751296Ab3AHUI3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 15:08:29 -0500
Date: Tue, 8 Jan 2013 21:08:25 +0100
From: Borislav Petkov <bp@alien8.de>
To: Jiri Slaby <jslaby@suse.cz>, Aaron Lu <aaron.lu@intel.com>
Cc: Shane Huang <Shane.Huang@amd.com>, Jeff Garzik <jgarzik@pobox.com>,
        linux-ide@vger.kernel.org,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: ata1: COMRESET failed
Message-ID: <20130108200825.GA23616@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Jiri Slaby <jslaby@suse.cz>, Aaron Lu <aaron.lu@intel.com>,
	Shane Huang <Shane.Huang@amd.com>, Jeff Garzik <jgarzik@pobox.com>,
	linux-ide@vger.kernel.org,
	Linux kernel mailing list <linux-kernel@vger.kernel.org>,
	Tejun Heo <tj@kernel.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>
References: <508A7A8A.7030908@suse.cz>
 <50BC8A1C.8070805@suse.cz>
 <20121203115734.GA32243@liondog.tnic>
 <20130107172425.GD5954@liondog.tnic>
 <50EB770A.4090302@intel.com>
 <50EC070C.2090101@suse.cz>
 <50EC7A29.9000105@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <50EC7A29.9000105@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 08, 2013 at 08:57:29PM +0100, Jiri Slaby wrote:
> Yes, updating the firmware from 2CV102HD to 2CV102M3 indeed helped...
> Thanks for the tip.

That's cool, so that's the second case where updating the drive's fw
helps, good to know for the future.

Aaron, thanks for helping with this.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
