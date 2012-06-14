Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932188Ab2FNQah (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 12:30:37 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:57407 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932087Ab2FNQaf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 12:30:35 -0400
From: Andreas Schwab <schwab@linux-m68k.org>
To: Dave Jones <davej@redhat.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: 3.5.rc2 tty buffering bug ?
References: <20120614161331.GA29687@redhat.com>
X-Yow: I brought my BOWLING BALL - and some DRUGS!!
Date: Thu, 14 Jun 2012 18:30:30 +0200
In-Reply-To: <20120614161331.GA29687@redhat.com> (Dave Jones's message of
	"Thu, 14 Jun 2012 12:13:31 -0400")
Message-ID: <m2k3z9onyx.fsf@igel.home>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Jones <davej@redhat.com> writes:

> How does 'begin' get printed a second time ?

It's buffered in stdio, which is then cloned.

Andreas.

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
