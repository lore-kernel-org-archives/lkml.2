Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756752Ab2I2Qtj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2012 12:49:39 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:42277 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756172Ab2I2Qth (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2012 12:49:37 -0400
Message-ID: <506726AF.8040307@gmail.com>
Date: Sat, 29 Sep 2012 18:49:51 +0200
From: Sasha Levin <levinsasha928@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120913 Thunderbird/15.0.1
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: Frederic Weisbecker <fweisbec@gmail.com>, Dave Jones <davej@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: rcu: eqs related warnings in linux-next
References: <50659D37.2020206@gmail.com> <20120928133633.GC12843@somewhere.redhat.com> <20120928173133.GB2498@linux.vnet.ibm.com> <50669952.1000805@gmail.com> <CAFTL4hzuh+iXPpKpyHWvpx3-Dwy9aq+poJLF_u=xcVfJPiaQVw@mail.gmail.com> <20120929133737.GB2551@linux.vnet.ibm.com>
In-Reply-To: <20120929133737.GB2551@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/29/2012 03:37 PM, Paul E. McKenney wrote:
> Sasha, is the easily reproducible?  If so, could you please try the
> previous patch?  It will likely give us more information on where
> this bug really lives.  (Yes, it might totally obscure the bug, but
> in that case we will just need to try some other perturbation.)

Unlike the last issue, this one is *very* non-reproducible. In fact, I've only hit it once so far.


Thanks,
Sasha
