Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757469Ab2JQRQH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 13:16:07 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:45350 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755751Ab2JQRQE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 13:16:04 -0400
Date: Wed, 17 Oct 2012 22:47:03 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Rabin Vincent <rabin@rab.in>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Peter Zijlstra <peterz@infradead.org>, oleg@redhat.com
Subject: Re: [PATCH 4/9] uprobes: allow arch access to xol slot
Message-ID: <20121017171703.GH11096@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <1350242593-17761-1-git-send-email-rabin@rab.in>
 <1350242593-17761-4-git-send-email-rabin@rab.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1350242593-17761-4-git-send-email-rabin@rab.in>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12101717-3534-0000-0000-00000DE56BA5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Rabin Vincent <rabin@rab.in> [2012-10-14 21:23:08]:

> Allow arches to customize how the instruction is filled into the xol
> slot.  ARM will use this to insert an undefined instruction after the
> real instruction in order to simulate a single step of the instruction
> without hardware support.
> 
> Signed-off-by: Rabin Vincent <rabin@rab.in>
> ---

The rest of the patches 4,5,6,7 look good. 

-- 
Thanks and Regards
Srikar

