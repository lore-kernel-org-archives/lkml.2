Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755496Ab1EPNse (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 09:48:34 -0400
Received: from vps.jankratochvil.net ([46.28.109.124]:42256 "EHLO
	host1.jankratochvil.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755394Ab1EPNsd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 09:48:33 -0400
Date: Mon, 16 May 2011 15:48:08 +0200
From: Jan Kratochvil <jan.kratochvil@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: oleg@redhat.com, vda.linux@googlemail.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org, indan@nul.nu
Subject: Re: PTRACE_SEIZE should not stop  [Re: [PATCH 02/11] ptrace:
 implement PTRACE_SEIZE]
Message-ID: <20110516134808.GA15806@host1.jankratochvil.net>
References: <1304869745-1073-1-git-send-email-tj@kernel.org>
 <1304869745-1073-3-git-send-email-tj@kernel.org>
 <20110515155602.GD31855@host1.jankratochvil.net>
 <20110515162630.GG23665@htj.dyndns.org>
 <20110515171512.GA24047@host1.jankratochvil.net>
 <20110515172505.GL23665@htj.dyndns.org>
 <20110515194829.GA27023@host1.jankratochvil.net>
 <20110516083113.GN23665@htj.dyndns.org>
 <20110516132123.GA13544@host1.jankratochvil.net>
 <20110516134510.GA23665@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110516134510.GA23665@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tejun,

On Mon, 16 May 2011 15:45:10 +0200, Tejun Heo wrote:
> I don't think INTERRUPT can be prioritized like that above existing
> trap conditions.  Traps are taken sometimes deep in the kernel
> (e.g. fork/exec) and often after modifying states irrevocably
> (e.g. signal is already dequeued on signal trap).  I don't think how
> it would be possible to rewind the state changes and replay it later.

OK, so that closes one of the major issues I was trying to get "fixed".


Thanks for info,
Jan
