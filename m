Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753669Ab0DMSYl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 14:24:41 -0400
Received: from rcsinet12.oracle.com ([148.87.113.124]:39147 "EHLO
	rcsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753506Ab0DMSYj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 14:24:39 -0400
Cc: Chris Mason <chris.mason@oracle.com>,
       Manfred Spraul <manfred@colorfullife.com>, jens.axboe@oracle.com,
       linux-kernel@vger.kernel.org
Message-Id: <E6863657-23AC-4782-B2B0-5C644DD9FE87@oracle.com>
From: Zach Brown <zach.brown@oracle.com>
To: Nick Piggin <npiggin@suse.de>
In-Reply-To: <20100413180945.GD5683@laptop>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v936)
Subject: Re: [PATCH 1/2] ipc semaphores: reduce ipc_lock contention in semtimedop
Date: Tue, 13 Apr 2010 11:24:15 -0700
References: <1271098163-3663-1-git-send-email-chris.mason@oracle.com> <1271098163-3663-2-git-send-email-chris.mason@oracle.com> <4BC4A6B2.1090906@colorfullife.com> <20100413173941.GI13327@think> <20100413180945.GD5683@laptop>
X-Mailer: Apple Mail (2.936)
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4BC4B6E1.012E:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> What about Zach's simpler wakeup API?

It's making slow progress in the background as a longer-term experiment.

http://oss.oracle.com/~zab/wake-many/

That URL still has an API description, patches, and little test  
utilities for the simple first draft.

- z
