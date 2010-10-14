Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754163Ab0JNCza (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 22:55:30 -0400
Received: from ozlabs.org ([203.10.76.45]:38522 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753827Ab0JNCz2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 22:55:28 -0400
Date: Thu, 14 Oct 2010 13:55:26 +1100
From: Tony Breeds <tony@bakeyournoodle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Feng Tang <feng.tang@intel.com>
Subject: Re: linux-next: Tree for October 13
Message-ID: <20101014025526.GD24185@ozlabs.org>
Mail-Followup-To: Andrew Morton <akpm@linux-foundation.org>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
	Thomas Gleixner <tglx@linutronix.de>,
	Feng Tang <feng.tang@intel.com>
References: <20101013154522.7b087a20.sfr@canb.auug.org.au>
 <20101013173826.f4b911b4.akpm@linux-foundation.org>
 <4CB651A4.60205@zytor.com>
 <20101013174740.f48e4ec2.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20101013174740.f48e4ec2.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 13, 2010 at 05:47:40PM -0700, Andrew Morton wrote:

> gcc-4.1.0.  Which is actually an officially banned compiler version:
> 
>  # if __GNUC_MINOR__ == 1 && __GNUC_PATCHLEVEL__ <= 1
>  #  error Your version of gcc miscompiles the __weak directive
> 
> lazyass here needs to find a new cross-compiler.

*cough*
http://kernel.org/pub/tools/crosstool/files/bin/

If there are problems let me know.

Yours Tony
