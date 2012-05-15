Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758157Ab2EOIef (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 04:34:35 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:33135 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757237Ab2EOIed (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 04:34:33 -0400
MIME-Version: 1.0
In-Reply-To: <CAKfTPtCfiY7A29+e50F+6awd8BjNJjg4=uNN4ReZfdS_4FbpkA@mail.gmail.com>
References: <CAKfTPtDSDAOAdv0GTDswZeRM7TmACrjok+5kddSaQpvy6_6xWw@mail.gmail.com>
	<CAKfTPtCfiY7A29+e50F+6awd8BjNJjg4=uNN4ReZfdS_4FbpkA@mail.gmail.com>
Date: Tue, 15 May 2012 16:34:33 +0800
Message-ID: <CANQmPXj_81NBBrTYCkhUO1k1i4WVu0iHwY1_10wDVOFWCSkvsw@mail.gmail.com>
Subject: Re: Plumbers: Tweaking scheduler policy micro-conf RFP
From: mou Chen <hi3766691@gmail.com>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        torvalds@linux-foundation.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vincent

There is no necessary to change the scheduling policy for for a
SPECIFIC work. In case changing the scheduling policy just for this
reason will drop the total performance at all. People know that
desktop scheduler is for interactivity and server scheduler is for
throughput and we are just designing a scheduler for these 2 groups of
task.

All right you may not agree with me at all. However, changing the
policy for a SPECIFIC work is unnecessary. Or it is more better to
share about "how to make a scheduler for yourselves" with people who
don't know how to write a scheduler. :-)

                                                      Chen
