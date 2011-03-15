Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757886Ab1COO1s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 10:27:48 -0400
Received: from mx2.netapp.com ([216.240.18.37]:22779 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755263Ab1COO1r convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 10:27:47 -0400
X-IronPort-AV: E=Sophos;i="4.62,322,1297065600"; 
   d="scan'208";a="530467485"
Subject: Re: [PATCH] RPC: return task->tk_status from
 rpc_wait_for_completion_task() in case of successfull task completion
From: Trond Myklebust <Trond.Myklebust@netapp.com>
To: Stanislav Kinsbursky <skinsbursky@parallels.com>
Cc: linux-nfs@vger.kernel.org, xemul@parallels.com, neilb@suse.de,
        linux-kernel@vger.kernel.org, bfields@fieldses.org,
        skinsbursky@openvz.org
In-Reply-To: <20110315141951.16564.72417.stgit@localhost6.localdomain6>
References: <20110315141951.16564.72417.stgit@localhost6.localdomain6>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Organization: NetApp Inc
Date: Tue, 15 Mar 2011 10:26:55 -0400
Message-ID: <1300199215.14093.1.camel@lade.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
X-OriginalArrivalTime: 15 Mar 2011 14:26:56.0455 (UTC) FILETIME=[0995A570:01CBE31D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-03-15 at 17:20 +0300, Stanislav Kinsbursky wrote:
> Some NFS and NLM routines doesn't check RPC task tk_status if
> rpc_wait_for_completion_task() returned 0 but have to.

Examples please. I'm not aware of any such cases.

Cheers
   Trond

-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com

