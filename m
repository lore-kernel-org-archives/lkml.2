Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755575Ab0IJRlM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 13:41:12 -0400
Received: from mx3.wp.pl ([212.77.101.7]:17576 "EHLO mx3.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750946Ab0IJRlK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 13:41:10 -0400
Date: Fri, 10 Sep 2010 19:50:38 +0200
From: Krzysztof Helt <krzysztof.h1@wp.pl>
To: Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org, vamos-dev@i4.informatik.uni-erlangen.de
Subject: Re: [PATCH 10/14] drivers/video: Removing undead ifdef ATAFB_FALCON
Message-Id: <20100910195038.cb8c6031.krzysztof.h1@wp.pl>
In-Reply-To: <c073783271e15767124fd95ec3c1cd4dcc9004e9.1283782701.git.qy03fugy@stud.informatik.uni-erlangen.de>
References: <cover.1283782698.git.qy03fugy@stud.informatik.uni-erlangen.de>
	<c073783271e15767124fd95ec3c1cd4dcc9004e9.1283782701.git.qy03fugy@stud.informatik.uni-erlangen.de>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.14.7; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-WP-AV: skaner antywirusowy poczty Wirtualnej Polski S. A.
X-WP-SPAM: NO 0000000 [4QF3]                               
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 6 Sep 2010 16:36:47 +0200
Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de> wrote:

> The ATAFB_FALCON ifdef isn't necessary at this point, because it is
> checked in an outer ifdef level already and has no effect here.
> 
> Signed-off-by: Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>
> ---

Right.

Acked-by: Krzysztof Helt <krzysztof.h1@wp.pl>
