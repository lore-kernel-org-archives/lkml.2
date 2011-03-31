Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758677Ab1CaQ2d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 12:28:33 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:40185 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753311Ab1CaQ2c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 12:28:32 -0400
Date: Thu, 31 Mar 2011 18:28:18 +0200
From: Borislav Petkov <bp@amd64.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Ingo Molnar <mingo@elte.hu>, "mingo@redhat.com" <mingo@redhat.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "bp@amd64.org" <bp@amd64.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
Subject: Re: [tip:x86/urgent] x86, amd-nb: Rename CPU PCI id define for F4
Message-ID: <20110331162818.GC9350@aftab>
References: <20110330183447.GA3668@aftab>
 <tip-cb6c8520f6f6bba7b7e1a6de3360a8edfd8243b6@git.kernel.org>
 <20110331090039.12358ee6@jbarnes-desktop>
 <20110331160552.GD9827@elte.hu>
 <20110331091401.64f2c81c@jbarnes-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110331091401.64f2c81c@jbarnes-desktop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 31, 2011 at 12:14:01PM -0400, Jesse Barnes wrote:
> > The new ID went upstream via cb293250c71f in the merge window, so i wanted to 
> > shorten the life-time of the obsoleted name - that will also reduce the chance 
> > of any conflicts.
> 
> Sounds good, thanks.

Yep, definitely a good idea since I have a couple of patches coming up
for the next merge window and they use this particular #define. That's
why I sent it out now, thinking it is trivial enough to go in and thus
to avoid conflicts at merge window time.

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
