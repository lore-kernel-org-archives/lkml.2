Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754522Ab1HEH5Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 03:57:24 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:60835 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751132Ab1HEH5V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 03:57:21 -0400
Date: Fri, 5 Aug 2011 09:57:17 +0200
From: Borislav Petkov <bp@amd64.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>, Ingo Molnar <mingo@elte.hu>
Cc: Tony Luck <tony.luck@intel.com>, EDAC devel <linux-edac@vger.kernel.org>,
        X86-ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] x86, MCE: Use MCE decoder notifier chain
Message-ID: <20110805075717.GA21162@aftab>
References: <1310999086-30870-1-git-send-email-bp@amd64.org>
 <20110802115853.GC15897@aftab>
 <4E3B3FDA.1050706@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E3B3FDA.1050706@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 04, 2011 at 08:56:58PM -0400, Mauro Carvalho Chehab wrote:
> Boris,
> 
> Em 02-08-2011 08:58, Borislav Petkov escreveu:
> > Ping?
> > 
> > Mauro, any progress on those below?
> 
> Sorry for taking a long time on that. I'm testing it right now, together with
> a few other patches for i7core.
> 
> I've added it (with a few conflict fixes) at:
> 	ssh://master.kernel.org/pub/scm/linux/kernel/git/mchehab/edac.git  linux_next
> 
> If everything works as before, I'll send it to Linus tomorrow, assuming that
> linux-next will catch them.

Ok, thanks.

Please bear in mind that the second patch depends on the first and
they both touch arch/x86 so you'd at least need Acked-by's from x86
maintainers. Ingo?

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
