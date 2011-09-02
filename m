Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751883Ab1IBXuc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 19:50:32 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48079 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751468Ab1IBXub (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 19:50:31 -0400
Date: Fri, 2 Sep 2011 16:50:20 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Bob Pearson <rpearson@systemfabricworks.com>
Cc: linux-kernel@vger.kernel.org, fzago@systemfabricworks.com,
        Joakim Tjernlund <joakim.tjernlund@transmode.se>,
        George Spelvin <linux@horizon.com>
Subject: Re: [PATCH v6 00/10] crc32
Message-Id: <20110902165020.7c6b5382.akpm@linux-foundation.org>
In-Reply-To: <4E5EB5CC.1010605@systemfabricworks.com>
References: <4E5EB5CC.1010605@systemfabricworks.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 31 Aug 2011 17:29:32 -0500
Bob Pearson <rpearson@systemfabricworks.com> wrote:

> This is an attempt to resolve all the issues that were left in the last review.
> There is one proposed change that is still causing a difference of opinion
> which has to do with the form of the loops and their performance on x86 and ppc
> This version has the change to the form that runs faster on x86 as an ifdef.
> 
> This patch series provides improved performance for computing the crc32
> polynomial on common hardware by adding the Slicing-by-8 algorithm to the
> existing algorithms already included. The new algorithm is very closely
> related to the existing algorithm so the extension requires small changes
> to implement.  Additionally it cleans up some warnings in the existing
> code and adds a kernel mode optional self test to replace the existing
> user mode self test.
> 
> A description of the existing and new algorithm is included in
> Documentation/crc32.txt.

So...  are the crc wars over yet?  I hope it's safe to look at the
patches now ;)

Please see Documentation/SubmittingPatches Section 15's discussion of
patch Subject: lines.

Is there any code in the kernel which uses the crc code so much that we
actually care about its performance?

