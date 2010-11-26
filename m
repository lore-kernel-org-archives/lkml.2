Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754833Ab0KZLIF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 06:08:05 -0500
Received: from hera.kernel.org ([140.211.167.34]:51096 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754430Ab0KZLID (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 06:08:03 -0500
Message-ID: <4CEF950B.9050608@kernel.org>
Date: Fri, 26 Nov 2010 12:07:55 +0100
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.12) Gecko/20101027 Lightning/1.0b2 Thunderbird/3.1.6
MIME-Version: 1.0
To: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
CC: linux-kernel@vger.kernel.org, h.mitake@gmail.com,
        Arjan van de Ven <arjan@linux.intel.com>,
        David Howells <dhowells@redhat.com>
Subject: Re: [PATCH] workqueue: check the allocation of system_unbound_wq
References: <1290737991-23163-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
In-Reply-To: <1290737991-23163-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 26 Nov 2010 11:07:57 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 11/26/2010 03:19 AM, Hitoshi Mitake wrote:
> I found a trivial bug on initialization of workqueue.
> Current init_workqueues doesn't check the result of
> allocation of system_unbound_wq, this should be checked
> like other queues.
> 
> Signed-off-by: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
> Cc: Arjan van de Ven <arjan@linux.intel.com>
> Cc: David Howells <dhowells@redhat.com>

Queued to wq#for-linus with new line adjustment.

Thanks a lot. :-)

-- 
tejun
