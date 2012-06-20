Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755809Ab2FTI7x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 04:59:53 -0400
Received: from merlin.infradead.org ([205.233.59.134]:42043 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755791Ab2FTI7v convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 04:59:51 -0400
Message-ID: <1340182778.21745.75.camel@twins>
Subject: Re: [PATCH 2/2] x86, microcode: Make reload interface per system
From: Peter Zijlstra <peterz@infradead.org>
To: Borislav Petkov <bp@amd64.org>
Cc: "Yu, Fenghua" <fenghua.yu@intel.com>, X86-ML <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date: Wed, 20 Jun 2012 10:59:38 +0200
In-Reply-To: <20120619232857.GH5996@aftab.osrc.amd.com>
References: <1340121811-4477-1-git-send-email-bp@amd64.org>
	 <1340121811-4477-3-git-send-email-bp@amd64.org>
	 <CANDHA0jf2fLOtg1E6CbyNM=omn=kj=YoRJ3VTkNA0AhkS-MLtg@mail.gmail.com>
	 <3E5A0FA7E9CA944F9D5414FEC6C7122007737623@ORSMSX105.amr.corp.intel.com>
	 <20120619232857.GH5996@aftab.osrc.amd.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-06-20 at 01:28 +0200, Borislav Petkov wrote:
> 
> which makes me wonder whether we still need that OLD INTERFACE.
> Henrique, any thoughts here? 

Yes I need it, I've no f'ing clue where to put the ucode image so that
the whole firmware mess can find it :-)


