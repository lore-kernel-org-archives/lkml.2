Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756121Ab2GBTgS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 15:36:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17565 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751219Ab2GBTgR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 15:36:17 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Hillf Danton <dhillf@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC patch] block: add round robin dispatch in noop IO scheduler
References: <CAJd=RBC=cZO8boOQMqJi=q9H2tZNOfsu_=VrkFt4_ExJCrLePQ@mail.gmail.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Mon, 02 Jul 2012 15:36:15 -0400
In-Reply-To: <CAJd=RBC=cZO8boOQMqJi=q9H2tZNOfsu_=VrkFt4_ExJCrLePQ@mail.gmail.com>
	(Hillf Danton's message of "Wed, 27 Jun 2012 21:55:51 +0800")
Message-ID: <x498vf2lzv4.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hillf Danton <dhillf@gmail.com> writes:

> Requests are grouped according to IO context, and dispatched in round
> robin, one request per context a time, then noop serves flash based
> disk "fair"?

NACK.  Noop means noop.  You can have a look, and maybe contribute to
the work that Shaohua Li is doing.  He proposed an IOPS-based scheduler
here:
  http://lwn.net/Articles/474164/

Cheers,
Jeff
