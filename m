Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754525Ab2BMLan (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 06:30:43 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:42179 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751619Ab2BMLam (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 06:30:42 -0500
MIME-Version: 1.0
Date: Mon, 13 Feb 2012 17:00:40 +0530
Message-ID: <CAG9fbzb=B66ku7bPWjJOZ7_EcShYqORypP8-hsvD-g7z9t4oHA@mail.gmail.com>
Subject: how to know list of files accessed
From: ranjith kumar <ranjithproxy@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
Suppose I downloaded linux kernel.
When I run "make", many of the .c files will be compiled.
I want to know which .c files are compiles and which .c files are not compiled.
Is there any way to know in linux?

Access time of the files which are compiled is not getting modified
when I run "make" . why?

Thanks in advance.
