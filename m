Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757667Ab2CHVoS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 16:44:18 -0500
Received: from toast.topped-with-meat.com ([204.197.218.159]:42468 "EHLO
	topped-with-meat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757468Ab2CHVoR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 16:44:17 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@hack.frob.com>
To: Jason Baron <jbaron@redhat.com>
X-Fcc: ~/Mail/lkml
Cc: akpm@linux-foundation.org, torvalds@linux-foundation.org, avi@redhat.com,
        cmetcalf@tilera.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2 v2] core dump: add VM_NODUMP, MADV_NODUMP, MADV_CLEAR_NODUMP
In-Reply-To: Jason Baron's message of  Thursday, 8 March 2012 16:29:30 -0500 <f52c6c288ec291c8cdc6176673d5b0d3d33a6f14.1331238525.git.jbaron@redhat.com>
References: <cover.1331238525.git.jbaron@redhat.com>
	<f52c6c288ec291c8cdc6176673d5b0d3d33a6f14.1331238525.git.jbaron@redhat.com>
X-Shopping-List: (1) Histrionic pond lions
   (2) Sanctimonious confessions
   (3) Stimulating solicitous pajamas
Message-Id: <20120308214417.328502C0C8@topped-with-meat.com>
Date: Thu,  8 Mar 2012 13:44:17 -0800 (PST)
X-CMAE-Score: 0
X-CMAE-Analysis: v=2.0 cv=fe7WOzsF c=1 sm=1 a=u2HnU3c4MckA:10
		a=kj9zAlcOel0A:10 a=HUqb8dNcSfkq7c8_H4QA:9 a=CjuIK1q_8ugA:10
		a=WkljmVdYkabdwxfqvArNOQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm vaguely dubious about the desireability of using this new feature.
(I would hate to try to debug a qemu bug from a dump where half the
interesting state was intentionally hidden from me.)  But I don't see
any problem with the implementation.

As to the interface, I think the bits are OK but it would be more
in keeping with the existing MADV_* names to call the new values
MADV_DONTDUMP and MADV_DODUMP.


Thanks,
Roland
