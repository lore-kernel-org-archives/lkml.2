Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964877Ab2AEXKc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 18:10:32 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:50972 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932235Ab2AEXKa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 18:10:30 -0500
MIME-Version: 1.0
Date: Thu, 5 Jan 2012 18:10:29 -0500
Message-ID: <CAHFgRy8GUhyBZonZ_3c2=COxnCJ9DhX6EiaKe3JpMWaSpYJWWw@mail.gmail.com>
Subject: panic - init: io.c:1312: Unhandled error from nih_io_destroy: Bad
 file descriptor
From: Miles Lane <miles.lane@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Suddenly, all my kernels are failing to boot.  These include ones from
Ubuntu 12.04 and my Linus' GIT kernels.  Any suggestions for what
might be broken?  Is it possible for me to fix this?

init: log.c:291: Assertion failed in log_io_error_handler: err->number == EIR
init: Caught abort, core dumped
init: io.c:1312: Unhandled error from nih_io_destroy: Bad file descriptor
init: Caught abort. core dumped
Kernel panic - not syncing: Attempted to kill init!
Pid: 1. comm: init Not tainted 3.2.0-rc7+ #70
 Call Trace:
  [<ffffffff812eee23>] panic+0x96/0x1a2
  [<ffffffff810386fb>] forget_original_parent+0x9b/0x1e5
  [<flffffff81038857>] exit_notify+0x12/0x139
  [<ffffffff81038e52>] do_exit+0x2fe/0x371
  [<ffffffff812fe48e>] ? retint_swapgs+0xe/0x13
  [<ffffffff81039079>] do_group_exit+0x7d/0xa8
  [<ffffffff810390b6>] sys_exit_group+0x12/0x12
  [<ffffffff812febfb>] system_call_fastpath+0x16/0x1b
panic occurred, switching back to text console
