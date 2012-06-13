Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753264Ab2FMNEe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 09:04:34 -0400
Received: from merlin.infradead.org ([205.233.59.134]:54607 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750987Ab2FMNEd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 09:04:33 -0400
Message-ID: <1339592667.8980.32.camel@twins>
Subject: Re: [BUG] perf: perf_output_sample() merge issue?
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>, mingo@elte.hu
Date: Wed, 13 Jun 2012 15:04:27 +0200
In-Reply-To: <CABPqkBQa8ndydqkMDvc3kzu84_96FbK77TUkrfO3eSPXmv3dhQ@mail.gmail.com>
References: <CABPqkBQa8ndydqkMDvc3kzu84_96FbK77TUkrfO3eSPXmv3dhQ@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-06-13 at 14:51 +0200, Stephane Eranian wrote:
> I think the intent of this commit was to add the watermark check
> at the very end of the perf_output_sample() and NOT between processing
> of RAW and BRANCH_STACK. Something may have gone wrong
> in the merge.
> 
> Can you confirm this? 

Yes very much so, good spotting. Weird stuff this merging.
