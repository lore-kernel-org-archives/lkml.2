Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754046Ab0IFO7U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 10:59:20 -0400
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:16750
	"EHLO VA3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752931Ab0IFO7O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 10:59:14 -0400
X-SpamScore: -15
X-BigFish: VPS-15(zz1432Nzz1202hzz8275bh15d4Rz32i2a8h43h61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0L8BYUQ-02-4OY-02
X-M-MSG: 
Date: Mon, 6 Sep 2010 16:57:39 +0200
From: Borislav Petkov <borislav.petkov@amd.com>
To: Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "vamos-dev@i4.informatik.uni-erlangen.de" 
	<vamos-dev@i4.informatik.uni-erlangen.de>
Subject: Re: [PATCH 05/14] arch/x86: Removing undead ifdef ACPI/X86_IO_ACPI
Message-ID: <20100906145739.GA25071@aftab>
References: <cover.1283782698.git.qy03fugy@stud.informatik.uni-erlangen.de>
 <d4376e6d79b8dc0f89a4b3ce4a880904a7b93ead.1283782701.git.qy03fugy@stud.informatik.uni-erlangen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <d4376e6d79b8dc0f89a4b3ce4a880904a7b93ead.1283782701.git.qy03fugy@stud.informatik.uni-erlangen.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>
Date: Mon, Sep 06, 2010 at 10:36:18AM -0400

> The ACPI/X86_IO_ACPI ifdef isn't necessary at this point, because it is
> checked in an outer ifdef level already and has no effect here.
> 
> Signed-off-by: Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>

Acked-by: Borislav Petkov <borislav.petkov@amd.com>

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632

