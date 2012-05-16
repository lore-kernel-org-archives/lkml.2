Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757753Ab2EPBuE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 21:50:04 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:64562 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932658Ab2EPBuB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 21:50:01 -0400
X-AuditID: 9c930197-b7be2ae000000ebb-5a-4fb307c481a5
From: Namhyung Kim <namhyung.kim@lge.com>
To: valdis.kletnieks@vt.edu
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org, Hyeoncheol Lee <cheol.lee@lge.com>
Subject: Re: [QUESTION] Kprobes as a module?
References: <87zk99zwb8.fsf@sejong.aot.lge.com>
	<52488.1337111535@turing-police.cc.vt.edu>
Date: Wed, 16 May 2012 10:48:06 +0900
In-Reply-To: <52488.1337111535@turing-police.cc.vt.edu> (valdis kletnieks's
	message of "Tue, 15 May 2012 15:52:15 -0400")
Message-ID: <871umkew15.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.95 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, 15 May 2012 15:52:15 -0400, valdis kletnieks wrote:
> On Tue, 15 May 2012 17:24:11 +0900, Namhyung Kim said:
>> Probably a dumb question :).
>> What prevents the kprobes from being built as a module? We want to use
>> the kprobes on our systems, but some guys worried about potential
>> security problems. So it'd be great if we can enable/load kprobes as
>> needed and then disable/unload after using it. Is it a possible senario?
>
> Any troublemaker who has the ability to set a kprobe would probably also
> have theability to just re-load the module before setting the kprobe (unless
> you go to a *lot* of trouble to compartmentalize the root user).
>
> So it's not clear there's a security benefit from making it a module.  If anything,
> it makes it *worse* because you can then surprise a sysadmin who *thought*
> they were running a KPROBES=n kernel by loading a module and turning it on...

Right, thanks for your comment.

Namhyung
