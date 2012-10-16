Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755031Ab2JPPSe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 11:18:34 -0400
Received: from mail.x86-64.org ([217.9.48.20]:45426 "EHLO mail.x86-64.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754980Ab2JPPSc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 11:18:32 -0400
Date: Tue, 16 Oct 2012 17:18:30 +0200
From: Borislav Petkov <bp@amd64.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: ata4.00: failed to get Identify Device Data, Emask 0x1
Message-ID: <20121016151830.GB24044@aftab.osrc.amd.com>
References: <20121016144932.GA24044@aftab.osrc.amd.com>
 <20121016155824.00d5b618@pyramind.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121016155824.00d5b618@pyramind.ukuu.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 16, 2012 at 03:58:24PM +0100, Alan Cox wrote:
> Can you check whether 3.6 works on them. I know 3.6 is horribly broken
> on several brands of AHCI controller (Jmicron for example). Dunno
> where Jeff is on fixing the regressions ?

If by "works" you mean I don't see the message there, then yes, it does.
Logs say the message started appearing on Oct 4th after me building
Linus master after the merge window started.

Ok, let me test 3.6.2 just in case ...<tests>... yes, no error message
there.

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
