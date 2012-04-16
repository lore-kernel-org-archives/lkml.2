Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753989Ab2DPNN7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 09:13:59 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:44676 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753431Ab2DPNN6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 09:13:58 -0400
From: Andreas Schwab <schwab@linux-m68k.org>
To: "Ulrich Windl" <Ulrich.Windl@rz.uni-regensburg.de>
Cc: <linux-kernel@vger.kernel.org>
Subject: Re: Q: When do files in /proc change their times?
References: <4F8BF2FD020000A1000097D2@gwsmtp1.uni-regensburg.de>
X-Yow: Gee, I feel kind of LIGHT in the head now, knowing I can't make
 my satellite dish PAYMENTS!
Date: Mon, 16 Apr 2012 15:13:51 +0200
In-Reply-To: <4F8BF2FD020000A1000097D2@gwsmtp1.uni-regensburg.de> (Ulrich
	Windl's message of "Mon, 16 Apr 2012 10:22:53 +0200")
Message-ID: <m2d377250w.fsf@igel.home>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.95 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Ulrich Windl" <Ulrich.Windl@rz.uni-regensburg.de> writes:

> I have a simple question: When do files in /proc show changed modification
> times?

Whenever the inode is dropped from the inode cache and then recreated.
The proc fs always uses the current time to set the inode times.

Andreas.

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
