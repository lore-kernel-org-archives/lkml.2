Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756295Ab1JSOVU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 10:21:20 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:58328 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755930Ab1JSOVT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 10:21:19 -0400
Date: Wed, 19 Oct 2011 16:20:57 +0200
From: Borislav Petkov <bp@amd64.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: X86-ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] x86, microcode, AMD: Add microcode revision to
 /proc/cpuinfo
Message-ID: <20111019142057.GA26786@aftab>
References: <1318865115-9904-1-git-send-email-bp@amd64.org>
 <1318865115-9904-3-git-send-email-bp@amd64.org>
 <20111018062509.GE16304@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111018062509.GE16304@elte.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 18, 2011 at 02:25:10AM -0400, Ingo Molnar wrote:
> The standard way we mention commits in changelogs is:
> 
>   Enable microcode revision output for AMD after commit 506ed6b53e00 
>   ("x86, intel: Output microcode revision in /proc/cpuinfo") did it 
>   for Intel.
> 
> ... because humans are pretty bad at transforming sha1's to the real 
> commit title when reading such text.

Why, I thought transforming sha1's to commit messages is one of the job
requirements of serious kernel hackers.

:-)

> Please fix the changelog for the first commit as well.

Done, git branch at

git://amd64.org/linux/bp.git tip-ucode

updated.

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
