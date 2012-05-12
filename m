Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755545Ab2ELMQm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2012 08:16:42 -0400
Received: from mail-qa0-f49.google.com ([209.85.216.49]:52022 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753131Ab2ELMQl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2012 08:16:41 -0400
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
Date: Sat, 12 May 2012 14:16:40 +0200
Message-ID: <CA+icZUUVUtiJoYUGo5unJyJVgW+iKj0yF0moOu4a_=NiSWenMg@mail.gmail.com>
Subject: Re: 3.3.5 regression: resume doesn't switch to X
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Alex Deucher <alexander.deucher@amd.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reading LKML offline (original post from [1]):

The only drm-radeon-kms patch between v3.3.4 and v3.3.5 was [2] (see
also series file in [3]):

1 From 700698e7c303f5095107c62a81872c2c3dad1702 Mon Sep 17 00:00:00 2001
2 From: Alex Deucher <alexander.deucher@amd.com>
3 Date: Fri, 27 Apr 2012 17:18:59 -0400
4 Subject: drm/radeon/kms: need to set up ss on DP bridges as well
5
6 From: Alex Deucher <alexander.deucher@amd.com>
7
8 commit 700698e7c303f5095107c62a81872c2c3dad1702 upstream.

Wanna try with a revert of it?

- Sedat -


[1] http://marc.info/?l=linux-kernel&m=133680721203159&w=2
[2] http://git.kernel.org/?p=linux/kernel/git/stable/stable-queue.git;a=blob;f=releases/3.3.5/drm-radeon-kms-need-to-set-up-ss-on-dp-bridges-as-well.patch;h=2c73bf8dbc7818091cb85d550e86307e78de8a3d;hb=HEAD
[3] http://git.kernel.org/?p=linux/kernel/git/stable/stable-queue.git;a=blob;f=releases/3.3.5/series
