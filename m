Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759999Ab0EDOcj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 10:32:39 -0400
Received: from one.firstfloor.org ([213.235.205.2]:55783 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754907Ab0EDOch (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 10:32:37 -0400
To: Robert Richter <robert.richter@amd.com>
Cc: John Villalovos <sodarock@gmail.com>, x86@kernel.org,
       oprofile-list@lists.sf.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Oprofile: Change CPUIDS from decimal to hex, and add some comments
From: Andi Kleen <andi@halobates.de>
References: <20100416170849.GA15932@linuxjohn.usersys.redhat.com>
	<20100504140328.GB6450@erda.amd.com>
Date: Tue, 04 May 2010 16:32:33 +0200
In-Reply-To: <20100504140328.GB6450@erda.amd.com> (Robert Richter's message of "Tue, 4 May 2010 16:03:28 +0200")
Message-ID: <87iq734u0u.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Richter <robert.richter@amd.com> writes:
>
> Please also remove the comments that describe the model as it will be
> hard to maintain this, if there are questions one should read the
> spec. So please also add some more details of the specification source
> to the patch description, I think it is:
>
>  Table B-1. CPUID Signature Values of DisplayFamily_DisplayModel
>
> in SDM Volume 3B.

Actually I tend to get it from the tables at the beginning of the
specification updates.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
