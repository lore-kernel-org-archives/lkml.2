Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755221Ab2JPUbX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 16:31:23 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:63592 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754195Ab2JPUbW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 16:31:22 -0400
MIME-Version: 1.0
In-Reply-To: <20121015171932.GA28723@linux.vnet.ibm.com>
References: <1350242593-17761-1-git-send-email-rabin@rab.in> <20121015171932.GA28723@linux.vnet.ibm.com>
From: Rabin Vincent <rabin@rab.in>
Date: Tue, 16 Oct 2012 22:30:41 +0200
X-Google-Sender-Auth: KFuQZntMsiNVi3eQAE2W-lR2I1s
Message-ID: <CAH+eYFAO8T2-S0DRBwGrwsLHoNY37oVhY=PWG_zweD=evQR+_g@mail.gmail.com>
Subject: Re: [PATCH 1/9] uprobes: move function declarations out of arch
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Peter Zijlstra <peterz@infradead.org>, oleg@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/10/15 Srikar Dronamraju <srikar@linux.vnet.ibm.com>:
> You need to take care of the powerpc port
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=commitdiff;h=8b7b80b9ebb46dd88fbb94e918297295cf312b59
>
> Also as Oleg pointed out, He has already posted changes on top of -tip.
> So it probably makes sense to redo these patches on top of those
> patches.

OK, will look into it.
