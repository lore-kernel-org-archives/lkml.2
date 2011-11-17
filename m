Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757391Ab1KQMgx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 07:36:53 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:45959 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757196Ab1KQMgv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 07:36:51 -0500
MIME-Version: 1.0
Date: Thu, 17 Nov 2011 13:36:50 +0100
Message-ID: <CALqGcGppqq0bN80ueGbdicB9=GGzkO2xm-4oUJHb=-WqsS0Pdg@mail.gmail.com>
Subject: core dumps and prctl(PR_SET_NAME)
From: Christoph Mathys <eraserix@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

We've recently started naming our threads using prctl(PR_SET_NAME,
...). For core dumps, we use the pattern "%e.core". %e is supposed to
expand to (according to Documentation/sysctl/kernel.txt of 3.0.9):

%e	executable filename (may be shortened)

However, after prctl was called, %e will expand to whatever name was
set in the call, not the executable filename anymore. This is not what
I would expect when reading the documentation. It also strikes me as
somewhat impractical. How do I know which application dumped core if
it should happen to assign names to its threads?

We are currently on 3.0.9 with PREEMPT_RT 25.

Please CC me on replies. Thanks!
Christoph
