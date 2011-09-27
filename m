Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753351Ab1I0Ura (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 16:47:30 -0400
Received: from smtp106.prem.mail.ac4.yahoo.com ([76.13.13.45]:43443 "HELO
	smtp106.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752435Ab1I0Ur3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 16:47:29 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: rxRKvRkVM1niBiadGqQ6xIi.g3ccumZF8OQaIJ9a3fSJrBO
 Kk2ntbHXstiGx4_2n_UC2Ea34Ka7qPQX6kDm.UJB.nHq3MJGnEmaS7_Rd3B8
 3PVdRFh.alJ_0NU3FR71myjdhRPqj63_u6.oEgbBrdHbd4QszyJoEs1j3lnO
 L7qYPaIkpLxuUIsu6ZM0DKjhNmaFuj6QMBx_O08mqXZn0RNOuXQB8lFm.9Ds
 MBCGKL2SmwRuR_FmZzfkZ6CXOMDdNoToellekDSkWfB61mUIcbl7fM_4gmAO
 HdnhOb2eUdG8JJZqBykKSR6vaR2Fz8Xk9R4ITPfDndnMPLT4XdBxbqxtV_cN
 7HD2U42vOZby2Xs2vPLaYIOjyartce7yTN25ww0xSSawBPYnnD7CZereJoyL
 dav20UVYpCvGPIUGf4awNofk-
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Tue, 27 Sep 2011 15:47:24 -0500 (CDT)
From: Christoph Lameter <cl@gentwo.org>
X-X-Sender: cl@router.home
To: David Rientjes <rientjes@google.com>
cc: Vasiliy Kulikov <segoon@openwall.com>, kernel-hardening@lists.openwall.com,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        Kees Cook <kees@ubuntu.com>, Dave Hansen <dave@linux.vnet.ibm.com>,
        Valdis.Kletnieks@vt.edu,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Alan Cox <alan@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] mm: restrict access to /proc/meminfo
In-Reply-To: <alpine.DEB.2.00.1109271328151.24402@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.00.1109271546320.13797@router.home>
References: <20110927175453.GA3393@albatros> <20110927175642.GA3432@albatros> <20110927193810.GA5416@albatros> <alpine.DEB.2.00.1109271459180.13797@router.home> <alpine.DEB.2.00.1109271328151.24402@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Sep 2011, David Rientjes wrote:

> It'll turn into another one of our infinite number of capabilities.  Does
> anything actually care about statistics at KB granularity these days?

Changing that to MB may also break things. It may be better to have
consistent system for access control to memory management counters that
are not related to a process.

