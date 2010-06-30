Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752757Ab0F3HU4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 03:20:56 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:37474 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752387Ab0F3HUy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 03:20:54 -0400
MIME-Version: 1.0
X-Originating-IP: [134.134.137.73]
Date: Wed, 30 Jun 2010 15:20:52 +0800
Message-ID: <AANLkTinrDVKmA4Jcr-JimhMKogjVzdLsbsB5beWJSVla@mail.gmail.com>
Subject: How to find a lost git commit?
From: Lin Ming <lin@ming.vg>
To: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi list,

I wrote some patch and checked it in my local branch.
But by accident, I run "git reset --hard" to reset the git head to
some other commit.

So now I can't find my patch because I don't know it's commit number.

Any idea?

Thanks,
Lin Ming
