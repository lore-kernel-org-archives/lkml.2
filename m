Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932138Ab2FTJmJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 05:42:09 -0400
Received: from merlin.infradead.org ([205.233.59.134]:47618 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932125Ab2FTJmG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 05:42:06 -0400
Message-ID: <1340185319.21745.84.camel@twins>
Subject: Re: [PATCH 00/10] perf, x86: Add northbridge counter support for
 AMD family 15h
From: Peter Zijlstra <peterz@infradead.org>
To: Robert Richter <robert.richter@amd.com>
Cc: Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Wed, 20 Jun 2012 11:41:59 +0200
In-Reply-To: <20120620092932.GH1478@erda.amd.com>
References: <1340129448-8690-1-git-send-email-robert.richter@amd.com>
	 <CABPqkBS9hRxKLsecVK+AgRue6oqTtAg4=0Dpd5Z2VwAUja50fw@mail.gmail.com>
	 <20120620092932.GH1478@erda.amd.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-06-20 at 11:29 +0200, Robert Richter wrote:
> But then I would prefer a homogeneous
> implementation over all AMD families. This would be a separate patch
> set that is independent from family 15h nb counter implementation. 

I realize you would prefer that, but I would really like fam15h to do
the right thing and maybe see if its possible to rework the fam10h code
to approach that, instead of the other way around.

Fam10h really is somewhat ugly, it would be ashame to carry that ugly
into fam15h which actually did the right thing here.
