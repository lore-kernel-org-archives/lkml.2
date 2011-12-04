Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751765Ab1LDGFt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Dec 2011 01:05:49 -0500
Received: from gherkin.frus.com ([192.158.254.49]:37350 "EHLO gherkin.frus.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751250Ab1LDGFs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Dec 2011 01:05:48 -0500
Date: Sun, 4 Dec 2011 00:05:44 -0600
From: Bob Tracy <rct@gherkin.frus.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Larry Finger <Larry.Finger@lwfinger.net>, Ingo Molnar <mingo@elte.hu>,
        Borislav Petkov <borislav.petkov@amd.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: 3.2-rc2 freezes on boot for AMD K6 - bisected to commit bcb80e53877c2045d9e52f4a71372c3fe6501f6f
Message-ID: <20111204060544.GA1881@gherkin.frus.com>
References: <4ED5B70F.606@lwfinger.net> <4ED5C640.8030102@linux.vnet.ibm.com> <4ED5D6C5.5050704@lwfinger.net> <4EDA89F2.9070107@lwfinger.net> <CA+55aFwWVeAGT2p3tohRLh7VL8f4ztGwAHZxBmosEAGKJfL+Qg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwWVeAGT2p3tohRLh7VL8f4ztGwAHZxBmosEAGKJfL+Qg@mail.gmail.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 03, 2011 at 03:07:56PM -0800, Linus Torvalds wrote:
> (...)
> IOW, I think the patch should be something like the attached (TOTALLY
> UNTESTED) patch. Larry, does this work for you? It just moves the
> rdmsr_safe() to the later function.

Works for me as well: AMD K6-III/450.

--Bob
