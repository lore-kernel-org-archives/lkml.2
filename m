Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753655Ab2FLTHC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 15:07:02 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:58951 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751506Ab2FLTHA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 15:07:00 -0400
Date: Tue, 12 Jun 2012 21:07:20 +0200
From: Borislav Petkov <bp@amd64.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Stephane Eranian <eranian@google.com>, linux-kernel@vger.kernel.org,
        peterz@infradead.org, andi@firstfloor.org, mingo@elte.hu,
        ming.m.lin@intel.com, Borislav Petkov <bp@amd64.org>,
        "Yu, Fenghua" <fenghua.yu@intel.com>
Subject: Re: [PATCH] perf/x86: check ucode before disabling PEBS on
 SandyBridge
Message-ID: <20120612190720.GA11137@aftab.osrc.amd.com>
References: <20120607071531.GA4849@quad>
 <4FD78BE6.4060207@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FD78BE6.4060207@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 12, 2012 at 11:35:18AM -0700, H. Peter Anvin wrote:
> Andi just alerted me to this thread.
> 
> I, Thomas and Borislav discussed this at LCE last year, and it really
> comes up that we have a *large* number of reasons to load microcode
> early.  We then need to keep the microcode around so that it can be
> loaded on APs, hotplug CPUs, and after S3 resume.
> 
> The protocol discussion happened in this thread:
> 
> http://marc.info/?i=1332512984-79664-1-git-send-email-trenn@suse.de
> 
> Fenghua Yu at Intel is currently working on the implementation.

Nice, this is the initrd cpio thing, cool, no changes needed for the
bootloader. Ping me when you have something ready so that I can start
testing it here too.

Thanks guys.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
