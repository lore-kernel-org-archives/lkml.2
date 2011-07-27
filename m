Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754627Ab1G0PuT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 11:50:19 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:57975 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751754Ab1G0PuQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 11:50:16 -0400
Date: Wed, 27 Jul 2011 17:49:57 +0200
From: Borislav Petkov <bp@amd64.org>
To: Avi Kivity <avi@redhat.com>
Cc: Borislav Petkov <bp@amd64.org>, Ingo Molnar <mingo@elte.hu>,
        "Przywara, Andre" <Andre.Przywara@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        "Pohlack, Martin" <Martin.Pohlack@amd.com>
Subject: Re: [PATCH] x86, AMD: Correct F15h IC aliasing issue
Message-ID: <20110727154957.GB19477@aftab>
References: <4E2F0498.8050005@zytor.com>
 <20110726183721.GF32536@aftab>
 <4E2F09BB.9060605@zytor.com>
 <4E2F1889.8030708@amd.com>
 <4E2F90A2.4030409@redhat.com>
 <20110727062120.GA5272@aftab>
 <20110727065932.GA16555@elte.hu>
 <4E2FDAD0.8000809@redhat.com>
 <20110727153731.GA19477@aftab>
 <4E30327C.5020509@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E30327C.5020509@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 27, 2011 at 11:45:00AM -0400, Avi Kivity wrote:
> What about F21h processors?  I see you're not checking them.
> 
> Is there any reason the check should not be made based on topology?

Because this patch addresses a performance improvement for the F15h
microarchitecture - that doesn't have anything to do with cache
topology.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
