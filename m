Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934691Ab2JYCtP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 22:49:15 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:52703 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933068Ab2JYCtM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 22:49:12 -0400
X-Greylist: delayed 75512 seconds by postgrey-1.27 at vger.kernel.org; Wed, 24 Oct 2012 22:49:12 EDT
X-AuditID: b753bd60-99054ba000002f78-11-5088a8a5ec44
Message-ID: <5088A8A5.8030608@hitachi.com>
Date: Thu, 25 Oct 2012 11:49:09 +0900
From: Masaki Kimura <masaki.kimura.kz@hitachi.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:16.0) Gecko/20121005 Thunderbird/16.0
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org
Subject: Re[2]:[RESEND PATCH] module: Fix kallsyms to show the last symbol
 properly
References: <508781AD.80902@hitachi.com> <87y5ivmmgj.fsf@rustcorp.com.au>
In-Reply-To: <87y5ivmmgj.fsf@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rusty,

Thank you for your review of my patch and improvement for it.

>So I prefer the following fix:
I also prefer your way of fix from readability point of view. 
I tested your patch and confirmed that it works fine.

Best Regards,
Masaki
