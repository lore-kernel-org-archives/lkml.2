Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754217Ab0JTVoa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 17:44:30 -0400
Received: from outmail148154.authsmtp.co.uk ([62.13.148.154]:57973 "EHLO
	outmail148154.authsmtp.co.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753812Ab0JTVo3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 17:44:29 -0400
X-Greylist: delayed 1023 seconds by postgrey-1.27 at vger.kernel.org; Wed, 20 Oct 2010 17:44:29 EDT
From: blp@cs.stanford.edu (Ben Pfaff)
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: Borislav Petkov <bp@amd64.org>, "H. Peter Anvin" <hpa@zytor.com>,
        "mingo\@redhat.com" <mingo@redhat.com>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tglx\@linutronix.de" <tglx@linutronix.de>,
        "jeremy.fitzhardinge\@citrix.com" <jeremy.fitzhardinge@citrix.com>,
        "linux-tip-commits\@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
Subject: Re: [tip:x86/mm] x86, mm: Fix incorrect data type in vmalloc_sync_all()
References: <20101020103642.GA3135@kryptos.osrc.amd.com>
	<tip-bfac67208d6d2a84fe7980187d3d2f21424dde59@git.kernel.org>
	<20101020195046.GB16147@aftab> <4CBF48C7.3050306@linux.intel.com>
Reply-To: blp@cs.stanford.edu
Reply-to: blp@cs.stanford.edu
Date: Wed, 20 Oct 2010 14:26:25 -0700
In-Reply-To: <4CBF48C7.3050306@linux.intel.com> (H. Peter Anvin's message of
	"Wed, 20 Oct 2010 12:53:43 -0700")
Message-ID: <87bp6osghq.fsf@benpfaff.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Server-Quench: b4319deb-dc90-11df-ab46-001185d377ca
X-AuthReport-Spam: If SPAM / abuse - report it at: http://www.authsmtp.com/abuse
X-AuthRoute: OCdwYQ8QAVZfSBwy AC4CFCFJRwtjIQdD FxoeKRdbOF4EFVUQ JBwCaX1YLBpGHQgB E2QJUVZSWl5xF2Jy aBRQawFDY09NQQRj T0pMQFdNFUs3CGd9 Z31WGhlwfgNBeTBx bUJgXj4JWEd7fBIo EFMARmQGeGZhPDYC ARJccR5UcAJLdhoR aVd4ByJDAzANdhEk HhdhL2BvejBaHWxF El9JZVcXEw4lHy50 RhYJGi81EEYZDyk6 MxVuNk8EEQ4QNA0s NFIlXVUTBAQDDAZp FkVJQG4x
X-Authentic-SMTP: 61633331373532.1000:706
X-AuthFastPath: 0 (Was 255)
X-AuthVirus-Status: No virus detected - but ensure you scan with your own anti-virus system.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"H. Peter Anvin" <hpa@linux.intel.com> writes:

> ... and that confused the scripts.  The way git wants it commentary
> information should go *after* the "---" line.
>
> (This is a constant problem, by the way: people seems to want to prefix,
> not suffix, their commentary; "cover letter" style.)  I suspect git
> needs to change, but it's hard to know exactly how to change it.

Recent Git has a "scissors" feature that can be used to insert a
cover letter above the commit message.
-- 
Peter Seebach on managing engineers:
"It's like herding cats, only most of the engineers are already
 sick of laser pointers."
