Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754788Ab1HERz2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 13:55:28 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:44064 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751082Ab1HERz0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 13:55:26 -0400
Date: Fri, 5 Aug 2011 19:55:22 +0200
From: Borislav Petkov <bp@amd64.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, Avi Kivity <avi@redhat.com>,
        "Przywara, Andre" <Andre.Przywara@amd.com>,
        "Pohlack, Martin" <Martin.Pohlack@amd.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -v3.1 0/3] x86, AMD: Correct F15h IC aliasing issue
Message-ID: <20110805175522.GA26217@aftab>
References: <1312550110-24160-1-git-send-email-bp@amd64.org>
 <4E3C2405.8090309@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E3C2405.8090309@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 05, 2011 at 01:10:29PM -0400, H. Peter Anvin wrote:
> Patch 2 I'm going to object to because it puts your run_on_bsp method
> into a different structure where all the existing methods for this
> already are in a way that looks totally gratuitous to me.  Why not just
> have a c_bsp_init on struct cpu_dev like all the other methods?

Indeed, cpu_dev is actually the only logical place to put them, thanks.
I'm sending updated versions as a reply to this message.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
