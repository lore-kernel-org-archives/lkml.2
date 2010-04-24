Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751822Ab0DXKqR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Apr 2010 06:46:17 -0400
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:50580 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750729Ab0DXKqQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Apr 2010 06:46:16 -0400
Message-ID: <4BD2CBFA.5030601@dcl.info.waseda.ac.jp>
Date: Sat, 24 Apr 2010 19:46:18 +0900
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091211 Shredder/3.0
MIME-Version: 1.0
To: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
CC: Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
       h.mitake@gmail.com, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Jens Axboe <jens.axboe@oracle.com>, Jason Baron <jbaron@redhat.com>,
       Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Subject: Re: [PATCH] perf lock: add "info" subcommand for dumping misc information
References: <1272074742-3654-2-git-send-regression-fweisbec@gmail.com> <1272105813-10465-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
In-Reply-To: <1272105813-10465-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/24/10 19:43, Hitoshi Mitake wrote:
 > Hi Frederic,
 >
 > I added "info" subcommand to perf lock,
 > this can be used as dumping metadata like thread or address of lock 
instances.
 > "map" was removed because info should do the work of it.
 >
 > This will be useful not only for debugging but also for ordinary 
analyzing.
 >
 > I made this patch on perf/core of your tree, could you queue this?

Sorry, I should add example of usage :(
I resend v2, please discard it.
