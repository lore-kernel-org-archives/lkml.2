Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934260Ab1KJMIy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 07:08:54 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:34243 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753112Ab1KJMIw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 07:08:52 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: linux-next: build failure after merge of the pm tree
Date: Thu, 10 Nov 2011 13:11:31 +0100
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc10+; KDE/4.6.0; x86_64; ; )
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>
References: <20111110133106.12e519d17f6a28adfee3b883@canb.auug.org.au>
In-Reply-To: <20111110133106.12e519d17f6a28adfee3b883@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201111101311.32012.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, November 10, 2011, Stephen Rothwell wrote:
> Hi Rafael,
> 
> After merging the pm tree, today's linux-next build (powerpc
> ppc64_defconfig) failed like this:
> 
> mm/oom_kill.c: In function 'select_bad_process':
> mm/oom_kill.c:326:5: error: implicit declaration of function 'thaw_process'
> 
> Caused by commit 944e192db53c ("freezer: rename thaw_process() to
> __thaw_task() and simplify the implementation").
> 
> I have used the pm tree from next-20111109 for today.

Thanks, I'll drop pm-freezer from my linux-next branch until that issue is
fixed.

Rafael
