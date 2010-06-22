Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758951Ab0FVI5n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 04:57:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21767 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754774Ab0FVI5l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 04:57:41 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Jiri Kosina <jkosina@suse.cz>
X-Fcc: ~/Mail/linus
Cc: Edward Allcutt <edward@allcutt.me.uk>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Dave Young <hidave.darkstar@gmail.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Oleg Nesterov <oleg@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Neil Horman <nhorman@tuxdriver.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] fs: limit maximum concurrent coredumps
In-Reply-To: Jiri Kosina's message of  Tuesday, 22 June 2010 10:44:15 +0200 <alpine.LNX.2.00.1006221043470.13809@pobox.suse.cz>
References: <1277164737-30055-1-git-send-email-edward@allcutt.me.uk>
	<20100622012303.BD72E402AD@magilla.sf.frob.com>
	<alpine.LNX.2.00.1006221043470.13809@pobox.suse.cz>
X-Shopping-List: (1) Promiscuous fads
   (2) Myopic typical emissions
   (3) Academic coolants
   (4) Inglorious benediction dandelions
Message-Id: <20100622085649.49D364C348@magilla.sf.frob.com>
Date: Tue, 22 Jun 2010 01:56:49 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> But priority settings don't apply any more for core dumping process, do 
> they?

Why wouldn't they?
