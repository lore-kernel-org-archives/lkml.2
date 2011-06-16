Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757344Ab1FPIto (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 04:49:44 -0400
Received: from studserv5b.stud.uni-hannover.de ([130.75.176.51]:48885 "EHLO
	studserv5b.stud.uni-hannover.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755722Ab1FPItn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 04:49:43 -0400
Date: Thu, 16 Jun 2011 10:49:40 +0200
From: Ingo Saitz <Ingo.Saitz@stud.uni-hannover.de>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Ingo Saitz <Ingo.Saitz@stud.uni-hannover.de>,
        Daniel Lezcano <daniel.lezcano@free.fr>,
        "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: Re: PROBLEM: /proc/$pid/ns/ access of zombies dies with null
 pointer
Message-ID: <20110616084940.GA12821@studserv2.stud.uni-hannover.de>
References: <20110615141948.GA2071@studserv2.stud.uni-hannover.de>
 <m1wrgmdb1j.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1wrgmdb1j.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 15, 2011 at 02:44:56PM -0700, Eric W. Biederman wrote:
> This fixes it for me.  Can you confirm?
> 
> >From 793925334f32e9026c22baee5c3c340f47d4ef7e Mon Sep 17 00:00:00 2001
> From: "Eric W. Biederman" <ebiederm@xmission.com>
> Date: Wed, 15 Jun 2011 12:47:04 -0700
> Subject: [PATCH] proc: Fix Oops on stat of /proc/<zombie pid>/ns/net

Yes, I can't trigger the bug with this patch applied anymore.
Thanks.

    Ingo
-- 
Kennedy's Lemma:
    If you can parse Perl, you can solve the Halting Problem.

http://www.perlmonks.org/?node_id=663393
