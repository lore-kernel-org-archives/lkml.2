Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759566Ab1EMQcD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 12:32:03 -0400
Received: from mga14.intel.com ([143.182.124.37]:24747 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759503Ab1EMQcB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 12:32:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,365,1301900400"; 
   d="scan'208";a="435694736"
From: Andi Kleen <andi@firstfloor.org>
To: =?utf-8?Q?K=C5=99i=C5=A1tof_=C5=BDelechovski?= 
	<giecrilj@stegny.2a.pl>
Cc: linux-kernel@vger.kernel.org
Subject: Re: size of /proc/kcore is not the physical RAM size
References: <201105131440.44747.giecrilj@stegny.2a.pl>
Date: Fri, 13 May 2011 09:31:13 -0700
In-Reply-To: <201105131440.44747.giecrilj@stegny.2a.pl> (=?utf-8?Q?=22K?=
 =?utf-8?Q?=C5=99i=C5=A1tof=09=C5=BDelechovski=22's?= message of "Fri, 13
 May 2011 14:40:41 +0200")
Message-ID: <m2aaeqzhny.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Křištof Želechovski <giecrilj@stegny.2a.pl> writes:

> [1.] One line summary of the problem:    
> 	Size of /proc/kcore is not the physical RAM size.
> [2.] Full description of the problem/report:
> 	Size of /proc/kcore is not the physical RAM size.

It contains virtual addresses and memory holes, so that's expected.
Not a bug.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
