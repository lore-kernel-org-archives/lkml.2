Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753965Ab0E1Moq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 08:44:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57086 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753379Ab0E1Mop (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 08:44:45 -0400
From: Andreas Schwab <schwab@redhat.com>
To: Rumen Bogdanovski <rbogdanovski@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: sys_geteuid() quesion
References: <AANLkTikkju0MNjQwDs-n9EszNTyIP2uE7kcepjVhVBmQ@mail.gmail.com>
X-Yow: Oh, FISH sticks, CHEEZ WHIZ, GIN fizz, SHOW BIZ!!
Date: Fri, 28 May 2010 14:44:41 +0200
In-Reply-To: <AANLkTikkju0MNjQwDs-n9EszNTyIP2uE7kcepjVhVBmQ@mail.gmail.com>
	(Rumen Bogdanovski's message of "Fri, 28 May 2010 15:07:21 +0300")
Message-ID: <m3r5kwureu.fsf@hase.home>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rumen Bogdanovski <rbogdanovski@gmail.com> writes:

> Or simply how can I a module know who is calling its read or write?

The current task is always (except in interrupt context) available in
current, and its euid is returned by current_euid().

Andreas.

-- 
Andreas Schwab, schwab@redhat.com
GPG Key fingerprint = D4E8 DBE3 3813 BB5D FA84  5EC7 45C6 250E 6F00 984E
"And now for something completely different."
