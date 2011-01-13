Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933053Ab1AMS3U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 13:29:20 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:46954 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932961Ab1AMS3S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 13:29:18 -0500
Date: Thu, 13 Jan 2011 19:30:25 +0100
From: Borislav Petkov <bp@amd64.org>
To: Manoj Iyer <manoj.iyer@canonical.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Matthew Garrett <mjg@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        "Herrmann3, Andreas" <Andreas.Herrmann3@amd.com>
Subject: Re: [PATCH] Quirk to fix suspend/resume on Lenovo Edge 11,13,14,15
Message-ID: <20110113183025.GE2006@aftab>
References: <1294934542-2411-1-git-send-email-manoj.iyer@canonical.com>
 <1294934542-2411-2-git-send-email-manoj.iyer@canonical.com>
 <20110113164616.GB21289@srcf.ucam.org>
 <alpine.LFD.2.00.1101131808450.2678@localhost6.localdomain6>
 <20110113172205.GA30866@kryptos.osrc.amd.com>
 <AANLkTinw23rtSERxAy6G_cu5=rvQeEzxvf3snsUOZE+z@mail.gmail.com>
 <20110113175531.GD2006@aftab>
 <AANLkTikDoRMoQjtN03eMoeacwottEixrFqcF8nJZWgKy@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTikDoRMoQjtN03eMoeacwottEixrFqcF8nJZWgKy@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 13, 2011 at 01:11:48PM -0500, Manoj Iyer wrote:
> Borislav,
> 
> Please see attached lspci output.

Thanks, that looks better. A stab in the dark:

Can you boot your machine with "nohpet" and try a suspend/resume cycle
to see whether that helps?

If that works, can you then boot normally (i.e. no "nohpet" option on
the command line) and wait ~5mins after resume to see whether your
machine comes out of the hang after all (the idea here is to wait for
the 32bit HPET counter to wrap around).

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
