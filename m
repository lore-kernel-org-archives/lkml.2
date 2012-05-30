Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752878Ab2E3Tms (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 15:42:48 -0400
Received: from smtp107.prem.mail.ac4.yahoo.com ([76.13.13.46]:31834 "HELO
	smtp107.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751471Ab2E3Tmr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 15:42:47 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: _6oKxCoVM1niD356fKoP_AsAoXjuTZt9C9YYst54A3l8LtR
 j2slWYpnId4p.QyjDnvpcJgTSZxi13yvulo.EywGKlYfa9xAaO4st6bYOEZv
 MDql9kNmuTMxiSc6IwGTFmnZ4mCkmVoNRNKqlCO4XEIeHO1TRDF.1G_Hd9ES
 eWziR4rHSkGXkxJk1bKy8VRXXaFHXwWWCAEdocLBF62SQRwkMizxLd17rPoa
 zTvpdYDydwQqDtugQElCSVQtRRWLi.3Jh9segs2r4KU0fSxUzjdW3.lDTdgC
 Na0sG1Go_Zf2cOrHBxyEl7MxyRXNJAm_wkDSHiNCnV9GGK3vEosjGWrv6N02
 n603RMvo9tnPFbOJolR9CXXUNCBQNQY7ju8QnbEBRFFCHgSyYBup78ThuhfG
 w
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Wed, 30 May 2012 14:42:42 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Andi Kleen <andi@firstfloor.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>, kosaki.motohiro@gmail.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Andrew Morton <akpm@google.com>, Dave Jones <davej@redhat.com>,
        Mel Gorman <mgorman@suse.de>, stable@vger.kernel.org, hughd@google.com,
        sivanich@sgi.com, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH 0/6] mempolicy memory corruption fixlet
In-Reply-To: <20120530193234.GV27374@one.firstfloor.org>
Message-ID: <alpine.DEB.2.00.1205301441350.31768@router.home>
References: <1338368529-21784-1-git-send-email-kosaki.motohiro@gmail.com> <CA+55aFzoVQ29C-AZYx=G62LErK+7HuTCpZhvovoyS0_KTGGZQg@mail.gmail.com> <alpine.DEB.2.00.1205301328550.31768@router.home> <20120530184638.GU27374@one.firstfloor.org>
 <alpine.DEB.2.00.1205301349230.31768@router.home> <20120530193234.GV27374@one.firstfloor.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 May 2012, Andi Kleen wrote:

> On Wed, May 30, 2012 at 01:50:02PM -0500, Christoph Lameter wrote:
> > On Wed, 30 May 2012, Andi Kleen wrote:
> >
> > > I always regretted that cpusets were no done with custom node lists.
> > > That would have been much cleaner and also likely faster than what we have.
> >
> > Could shared memory policies ignore cpuset constraints?
>
> Only if noone uses cpusets as a "security" mechanism, just for a "soft policy"
> Even with soft policy you could well break someone's setup.

Well at least lets exempt shared memory from memory migration and memory
policy updates. That seems to be causing many of these issues.


