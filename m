Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759006Ab1D2O0J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 10:26:09 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:55056 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758610Ab1D2O0H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 10:26:07 -0400
Date: Fri, 29 Apr 2011 16:25:34 +0200
From: Borislav Petkov <bp@amd64.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Borislav Petkov <bp@amd64.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>, Tony Luck <tony.luck@intel.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        EDAC devel <linux-edac@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 00/18] RAS daemon: Easter Eggs Edition
Message-ID: <20110429142534.GD18746@aftab>
References: <1303576100-425-1-git-send-email-bp@amd64.org>
 <20110429140844.GB1768@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110429140844.GB1768@nowhere>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 29, 2011 at 10:08:48AM -0400, Frederic Weisbecker wrote:
> 
> If you want to accelerate that, I suggest you cut your patchset into smaller
> sets and focus on merging them piece by piece. Few people are going to review
> 18 patches at once. They may plan to scatter their review over days but
> that doesn't scale well, and it naturally reduces the number of reviewers.
> 
> You could start with exporting trace things into tools/trace, post the
> few concerned patches and iterate them until everyone is happy. Then
> switch to another subset of the big thing.

Hi Frederic,

I can definitely do that. I just wanted to know before I do it though,
whether the general direction is ok and whether people are fine with the
changes, i.e. Arnaldo, Ingo, Peter, Steven, any reactions? If yes, I can
get to work and split the big pile into more digestible pieces.

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
