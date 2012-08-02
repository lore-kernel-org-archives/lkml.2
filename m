Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752120Ab2HBUkT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 16:40:19 -0400
Received: from smtp102.prem.mail.ac4.yahoo.com ([76.13.13.41]:43216 "HELO
	smtp102.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750949Ab2HBUkQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 16:40:16 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: aAvE56wVM1kxmzipz.mLyScVDmfZYOhB15FqYAxSXHMHPgH
 F8egLSGjfhzEq9BjKm7iN5i.6gzvNzCOwGc4jQwv28FPHbnguvN6QDH26n45
 5oASzi0NtxGL85pXkkY2Fk7lNEjDacf6mkYeTjKRKls9ce6BOSxs3KgKqm_4
 4On3f4WgtMCmgEjDqF8PzvBTtZ5R56tUvNj40c8X1ZRP5RK7caz9tHnKP.g1
 nHmh2q68kqXaAaNTcLA8XKd.GvMHuXd4Pmge9FKf_XY_9uzTtmPi5bO_Hdgd
 jV61ox.2qe2DlFfdIM0eCjV5ZCjXfl8E_3ZoDBEqIT_SBauNWQJouf6kWsIG
 2m7GATEl0mBT_9Wyyh3Kgy_aVK_1.zu0PzK9C_.FT7QXaFgViD7im0XlXvgd
 SQGvjh285aKN3gi8wDRfAw3dgQqB0oVUabmi4HFUq62rqddoIwq0-
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Thu, 2 Aug 2012 15:40:11 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: mingo@kernel.org, riel@redhat.com, oleg@redhat.com, pjt@google.com,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        tglx@linutronix.de, Lee.Schermerhorn@hp.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 19/19] mm, numa: retry failed page migrations
In-Reply-To: <20120731192809.489683051@chello.nl>
Message-ID: <alpine.DEB.2.00.1208021538180.32229@router.home>
References: <20120731191204.540691987@chello.nl> <20120731192809.489683051@chello.nl>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 31 Jul 2012, Peter Zijlstra wrote:

> Keep track of how many NUMA page migrations succeeded and
> failed (in a way that wants retrying later) per process.

It would be good if we could also somehow determine if that
migration actually made sense?

Were there enough accesses to the page so that the effort to migrate
the page was amortized?

Still skeptical on this endeavor.

