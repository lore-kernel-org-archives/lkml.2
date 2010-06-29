Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756590Ab0F2PoV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 11:44:21 -0400
Received: from hera.kernel.org ([140.211.167.34]:39001 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756492Ab0F2PoU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 11:44:20 -0400
Message-ID: <4C2A145E.8030608@kernel.org>
Date: Tue, 29 Jun 2010 17:42:22 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100317 SUSE/3.0.4-1.1.1 Thunderbird/3.0.4
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: torvalds@linux-foundation.org, mingo@elte.hu, linux-kernel@vger.kernel.org,
       jeff@garzik.org, akpm@linux-foundation.org, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       oleg@redhat.com, axboe@kernel.dk, dwalker@codeaurora.org,
       stefanr@s5r6.in-berlin.de, florian@mickler.org, andi@firstfloor.org,
       mst@redhat.com, randy.dunlap@oracle.com
Subject: Re: [PATCH 12/35] workqueue: update cwq alignement
References: <1277759063-24607-1-git-send-email-tj@kernel.org> <1277759063-24607-13-git-send-email-tj@kernel.org> <20100628224755.GA10104@nowhere> <4C29A33D.2060407@kernel.org> <20100629123632.GB5318@nowhere>
In-Reply-To: <20100629123632.GB5318@nowhere>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 29 Jun 2010 15:42:31 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 06/29/2010 02:36 PM, Frederic Weisbecker wrote:
> But then, if each cpu pointers are aligned, the struct itself doesn't need
> to be aligned in its size right? It would need to if multiple elements
> were allocated per cpu but for this struct we only have one per cpu. So
> what seems to matter wrt alignment is only the base pointer of these structs,
> not the size.

Yeap, sure, but how does it matter?

Thanks.

-- 
tejun
