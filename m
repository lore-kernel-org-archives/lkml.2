Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753445Ab0DTF1r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 01:27:47 -0400
Received: from mail.skyhub.de ([78.46.96.112]:60710 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751701Ab0DTF1q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 01:27:46 -0400
Date: Tue, 20 Apr 2010 07:27:40 +0200
From: Borislav Petkov <bp@alien8.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>
Subject: Re: [Bug #15730] Ugly rmap NULL ptr deref oopsie on hibernate (was
 Linux 2.6.34-rc3)
Message-ID: <20100420052740.GA20482@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Kernel Testers List <kernel-testers@vger.kernel.org>,
	Maciej Rutecki <maciej.rutecki@gmail.com>
References: <deuQKFRcc0B.A.3EG.BRSzLB@tosh>
 <YeFfFNFyTSF.A.K_G.dRSzLB@tosh>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YeFfFNFyTSF.A.K_G.dRSzLB@tosh>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Rafael J. Wysocki" <rjw@sisk.pl>
Date: Tue, Apr 20, 2010 at 05:19:23AM +0200

> This message has been generated automatically as a part of a summary report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.33.  Please verify if it still should be listed and let the tracking team
> know (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15730
> Subject		: Ugly rmap NULL ptr deref oopsie on hibernate (was Linux 2.6.34-rc3)
> Submitter	: Borislav Petkov <bp@alien8.de>
> Date		: 2010-04-02 17:59 (18 days old)
> Message-ID	: <20100402175937.GA19690@liondog.tnic>
> References	: http://marc.info/?l=linux-kernel&m=127023173329741&w=2

Fixed by commit ea90002b0fa7bdee86ec22eba1d951f30bf043a6.

-- 
Regards/Gruss,
    Boris.
