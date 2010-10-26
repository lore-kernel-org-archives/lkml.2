Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760099Ab0JZRBt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 13:01:49 -0400
Received: from one.firstfloor.org ([213.235.205.2]:33871 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753073Ab0JZRBs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 13:01:48 -0400
Date: Tue, 26 Oct 2010 19:01:43 +0200
From: Andi Kleen <andi@firstfloor.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andi Kleen <andi@firstfloor.org>, kvm@vger.kernel.org, avi@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: fyi: gcc33-hammer crashes when compiling kvm emulate.c
Message-ID: <20101026170142.GD29961@basil.fritz.box>
References: <20101026123828.GA30434@basil.fritz.box>
 <4CC70333.80400@zytor.com>
 <20101026163748.GB29961@basil.fritz.box>
 <4CC705ED.1020105@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CC705ED.1020105@zytor.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Not unless they are actively known to break.  People get huffy about it

Well they do -- i just found out.

> because even if it is known to have problems it doesn't break *their*
> particular configuration.  I'm getting to be of the opinion that people
> who compile modern kernels with ancient compilers and expect it to work
> are suffering from some particular kind of insanity -- it's nothing the
> distros do.  The only exception are embedded people who compile with the
> latest 3.4 gcc; they have explained they do so because newer gccs have
> too many dependencies (the actual compiler, not the generated code) and
> for speed.

At least in the old days the main reason for gcc 3 was build speed.
AKPM and some others used to be fond of that.

3.x is apparently much faster than 4.x

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
