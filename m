Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753955Ab0K2Ncn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 08:32:43 -0500
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:55138 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753522Ab0K2Ncm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 08:32:42 -0500
Message-ID: <4CF3AB79.8@dcl.info.waseda.ac.jp>
Date: Mon, 29 Nov 2010 22:32:41 +0900
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.14) Gecko/20101117 Shredder/3.0.9
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: linux-kernel@vger.kernel.org, h.mitake@gmail.com,
        Arjan van de Ven <arjan@linux.intel.com>,
        David Howells <dhowells@redhat.com>
Subject: Re: [PATCH] workqueue: check the allocation of system_unbound_wq
References: <1290737991-23163-1-git-send-email-mitake@dcl.info.waseda.ac.jp> <4CEF950B.9050608@kernel.org>
In-Reply-To: <4CEF950B.9050608@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010年11月26日 20:07, Tejun Heo wrote:
 > Hello,
 >
 > On 11/26/2010 03:19 AM, Hitoshi Mitake wrote:
 >> I found a trivial bug on initialization of workqueue.
 >> Current init_workqueues doesn't check the result of
 >> allocation of system_unbound_wq, this should be checked
 >> like other queues.
 >>
 >> Signed-off-by: Hitoshi Mitake<mitake@dcl.info.waseda.ac.jp>
 >> Cc: Arjan van de Ven<arjan@linux.intel.com>
 >> Cc: David Howells<dhowells@redhat.com>
 >
 > Queued to wq#for-linus with new line adjustment.
 >
 > Thanks a lot. :-)
 >

Hi Tejun,
Thanks for your adjustment and applying :)
