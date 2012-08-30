Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753693Ab2H3Q3c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 12:29:32 -0400
Received: from mail.skyhub.de ([78.46.96.112]:50293 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750961Ab2H3Q33 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 12:29:29 -0400
Date: Thu, 30 Aug 2012 18:29:38 +0200
From: Borislav Petkov <bp@alien8.de>
To: Jan Engelhardt <jengelh@inai.de>
Cc: Andy Lutomirski <luto@amacapital.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-ide@vger.kernel.org, Bjoern Franke <bjo@nord-west.org>,
        Tim Nufire <linux_ide_tim@ibink.com>
Subject: Re: Which disk is ata4?
Message-ID: <20120830162938.GA24523@x1.osrc.amd.com>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Jan Engelhardt <jengelh@inai.de>,
	Andy Lutomirski <luto@amacapital.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-ide@vger.kernel.org, Bjoern Franke <bjo@nord-west.org>,
	Tim Nufire <linux_ide_tim@ibink.com>
References: <CALCETrW-LFzcHYgx=thQiuTfU8RdRBrtXwE7QboWpNrjz4An4A@mail.gmail.com>
 <alpine.LNX.2.01.1208301809370.25988@frira.zrqbmnf.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.01.1208301809370.25988@frira.zrqbmnf.qr>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 30, 2012 at 06:14:46PM +0200, Jan Engelhardt wrote:
> This tells me everything to replace a disk.
> 1. sdparm -C stop /dev/sdb
> 2. Removing Z1F0KR3H from the chassis.

Yep, the serial number is the best suggestion so far.

Are we sure this serial number is always programmed in by the hdd
vendors so that sdparm can read it out?

I'm thinking here of the DMI debacle of some vendors.

Thanks.

-- 
Regards/Gruss,
Boris.
