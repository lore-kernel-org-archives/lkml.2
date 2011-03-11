Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752732Ab1CKTyk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 14:54:40 -0500
Received: from www.tglx.de ([62.245.132.106]:53298 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751553Ab1CKTyh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 14:54:37 -0500
Date: Fri, 11 Mar 2011 20:54:16 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
        linux-kernel@vger.kernel.org, fweisbec@gmail.com,
        a.p.zijlstra@chello.nl, namhyung@gmail.com, ssp@redhat.com
cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/cleanups] x86, dumpstack: Correct stack dump info when
 frame pointer is available
In-Reply-To: <tip-074206a787e4dfdc4c290789ab6604c7f9e691ca@git.kernel.org>
Message-ID: <alpine.LFD.2.00.1103112052070.2787@localhost6.localdomain6>
References: <1299584662-24421-1-git-send-email-namhyung@gmail.com> <tip-074206a787e4dfdc4c290789ab6604c7f9e691ca@git.kernel.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463795968-1430451757-1299873257=:2787"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463795968-1430451757-1299873257=:2787
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Thu, 10 Mar 2011, tip-bot for Namhyung Kim wrote:

> Commit-ID:  074206a787e4dfdc4c290789ab6604c7f9e691ca
> Gitweb:     http://git.kernel.org/tip/074206a787e4dfdc4c290789ab6604c7f9e691ca
> Author:     Namhyung Kim <namhyung@gmail.com>
> AuthorDate: Tue, 8 Mar 2011 20:44:19 +0900
> Committer:  Thomas Gleixner <tglx@linutronix.de>
> CommitDate: Thu, 10 Mar 2011 23:20:30 +0100
> 
> x86, dumpstack: Correct stack dump info when frame pointer is available

Dropped it due to:

arch/x86/oprofile/backtrace.c:130:8: error: too few arguments to function ‘dump_trace’

Thanks,

	tglx
---1463795968-1430451757-1299873257=:2787--
