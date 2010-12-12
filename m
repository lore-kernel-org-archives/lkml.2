Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753150Ab0LLNuS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 08:50:18 -0500
Received: from mail-ew0-f45.google.com ([209.85.215.45]:61140 "EHLO
	mail-ew0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752736Ab0LLNuQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 08:50:16 -0500
MIME-Version: 1.0
From: Tom Gundersen <teg@jklm.no>
Date: Sun, 12 Dec 2010 14:49:54 +0100
Message-ID: <AANLkTimdBb-j=8qrkO+dbH6ATE_64vODCGbfqO=H5YGZ@mail.gmail.com>
Subject: Re: [RFC/RFT PATCH] sched: automated per tty task groups
To: Mike Galbraith <efault@gmx.de>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mike,

I have a question about your patch:

If I understand sched-rt-group.txt correctly, a non-root user will not
be able to run rt tasks if it is in a cgroup that has not been
explicitly given non-zero bandwidth. I could not see from your patch
where the bandwidth is assigned. Care to explain how it works?

Sorry if this has already been discussed (or if it should be obvious).

Cheers,

Tom
