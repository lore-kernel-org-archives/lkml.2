Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932471Ab1JZHx4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 03:53:56 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:34030 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932117Ab1JZHxz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 03:53:55 -0400
MIME-Version: 1.0
In-Reply-To: <1319606151-29707-1-git-send-email-sonic.adi@gmail.com>
References: <1319606151-29707-1-git-send-email-sonic.adi@gmail.com>
From: Mike Frysinger <vapier@gentoo.org>
Date: Wed, 26 Oct 2011 03:53:35 -0400
X-Google-Sender-Auth: 5oFYuylPVu4ccXAu1_KKLi_Z8B0
Message-ID: <CAJaTeTqsjjjS=Myt_gfPzOfF4mzqZ1pz2NJE95Gq6g_O0aOijA@mail.gmail.com>
Subject: Re: [uclinux-dist-devel] [PATCH] mutex:SMP:bf561:Run smp memory
 barrier after take atomic lock in mutex_fastpath APIs.
To: Sonic Zhang <sonic.adi@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, uclinux-dist-devel@blackfin.uclinux.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

unfortunately, this is incorrect.  please see the thread:
https://lkml.org/lkml/2011/5/29/233
-mike
