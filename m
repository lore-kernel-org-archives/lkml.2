Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757066Ab2FTQJH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 12:09:07 -0400
Received: from merlin.infradead.org ([205.233.59.134]:45570 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757023Ab2FTQJF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 12:09:05 -0400
Message-ID: <1340208537.21745.116.camel@twins>
Subject: Re: [PATCH 00/10] perf, x86: Add northbridge counter support for
 AMD family 15h
From: Peter Zijlstra <peterz@infradead.org>
To: Robert Richter <robert.richter@amd.com>
Cc: Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Wed, 20 Jun 2012 18:08:57 +0200
In-Reply-To: <1340207670.21745.108.camel@twins>
References: <1340129448-8690-1-git-send-email-robert.richter@amd.com>
	 <CABPqkBS9hRxKLsecVK+AgRue6oqTtAg4=0Dpd5Z2VwAUja50fw@mail.gmail.com>
	 <20120620092932.GH1478@erda.amd.com> <1340185084.21745.81.camel@twins>
	 <20120620100031.GI1478@erda.amd.com> <1340187373.21745.95.camel@twins>
	 <20120620122941.GH5046@erda.amd.com> <1340207670.21745.108.camel@twins>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-06-20 at 17:54 +0200, Peter Zijlstra wrote:
> Yeah, there's a little bit of 'duplicated' code, but that's
> unavoidable.

Also, you don't need to replicate the entire x86_pmu thing, most of that
is trying to share stuff between the various x86 core pmu things, like
p6,p4,intel,amd etc.. If you only support the one amd uncore things
become a lot easier.
