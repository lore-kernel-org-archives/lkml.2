Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932486Ab2GCKwu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 06:52:50 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:44585 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754174Ab2GCKwt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 06:52:49 -0400
Date: Tue, 3 Jul 2012 12:52:41 +0200
From: Borislav Petkov <bp@amd64.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Borislav Petkov <bp@amd64.org>,
        Ingo Molnar <mingo@kernel.org>, X86-ML <x86@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Andreas Herrmann <andreas.herrmann3@amd.com>
Subject: Re: [PATCH -v2 0/2] x86, microcode: Reload ucode only per-system
Message-ID: <20120703105241.GC12820@aftab.osrc.amd.com>
References: <1340280437-7718-1-git-send-email-bp@amd64.org>
 <20120630174503.GA24854@aftab.osrc.amd.com>
 <1341222838.23484.1.camel@twins>
 <29cea64a-e041-48ba-bf3e-0965740b862b@email.android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <29cea64a-e041-48ba-bf3e-0965740b862b@email.android.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 02, 2012 at 06:05:56AM -0700, H. Peter Anvin wrote:
> I put them into x86/microcode already.

Actually with Peter's stuff I meant the ucode version checking callback:

http://marc.info/?l=linux-kernel&m=134074741324448

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
