Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755767Ab2GGAnI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 20:43:08 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:64338 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751800Ab2GGAnG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 20:43:06 -0400
X-Nat-Received: from [202.181.97.72]:60776 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1341621782.30242
To: alex.shi@intel.com, linux-kernel@vger.kernel.org, hpa@zytor.com
Subject: Re: Fwd: Re: [linux-next-20120706] x86/mm: incompatible pointer typewarning.
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <4FF6F14C.3070104@intel.com>
	<4FF6F1E9.7050709@intel.com>
In-Reply-To: <4FF6F1E9.7050709@intel.com>
Message-Id: <201207070943.DBB17689.FOMQJtOFLHOVFS@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Sat, 7 Jul 2012 09:43:00 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.44/RELEASE, bases: 06072012 #8538937, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alex Shi wrote:
> Thanks for your report, mm should means mm_struct. no vma. My fault.
> Could you like try this patch.

Builds OK. Thank you.

> From 97781231b130e7f7fced12244653ed9b9946c944 Mon Sep 17 00:00:00 2001
> From: Alex Shi <alex.shi@intel.com>
> Date: Fri, 6 Jul 2012 20:49:25 +0800
> Subject: [PATCH] x86/tlb: fix allnoconfig building warning
> 
> The incompatible parameter of flush_tlb_mm_range cause build warning.
> Fix it by correct parameter.
