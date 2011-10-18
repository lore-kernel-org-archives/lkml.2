Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757092Ab1JRG0u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 02:26:50 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:46206 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755906Ab1JRG0r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 02:26:47 -0400
Date: Tue, 18 Oct 2011 08:25:10 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Borislav Petkov <bp@amd64.org>
Cc: X86-ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: Re: [PATCH 2/2] x86, microcode, AMD: Add microcode revision to
 /proc/cpuinfo
Message-ID: <20111018062509.GE16304@elte.hu>
References: <1318865115-9904-1-git-send-email-bp@amd64.org>
 <1318865115-9904-3-git-send-email-bp@amd64.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1318865115-9904-3-git-send-email-bp@amd64.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Borislav Petkov <bp@amd64.org> wrote:

> From: Borislav Petkov <borislav.petkov@amd.com>
> 
> Enable microcode revision output for AMD after
> 506ed6b53e00ba303ad778122f08e1fca7cf5efb did it for Intel.

The standard way we mention commits in changelogs is:

  Enable microcode revision output for AMD after commit 506ed6b53e00 
  ("x86, intel: Output microcode revision in /proc/cpuinfo") did it 
  for Intel.

... because humans are pretty bad at transforming sha1's to the real 
commit title when reading such text.

Please fix the changelog for the first commit as well.

The changes look good otherwise.

Thanks,

	Ingo
