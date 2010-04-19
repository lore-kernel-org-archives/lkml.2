Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752554Ab0DSIPx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 04:15:53 -0400
Received: from hera.kernel.org ([140.211.167.34]:44978 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751162Ab0DSIPw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 04:15:52 -0400
Message-ID: <4BCC11FC.50802@kernel.org>
Date: Mon, 19 Apr 2010 17:19:08 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Jan Kiszka <jan.kiszka@web.de>
CC: Jeff Dike <jdike@addtoit.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       user-mode-linux-devel@lists.sourceforge.net,
       Tiger Yang <tiger.yang@oracle.com>
Subject: Re: [PATCH] uml: Fix build breakage after slab.h changes
References: <4BCB353A.3040806@web.de> <4BCB788E.2040501@kernel.org> <4BCC07C0.5050601@web.de>
In-Reply-To: <4BCC07C0.5050601@web.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 19 Apr 2010 08:15:34 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/19/2010 04:35 PM, Jan Kiszka wrote:
> Good question. Does such a tree exist? I'm sitting on a few more um
> cleanups & fixes, and so far I'm working against Linus' tree as I failed
> to find anything more recent.

Well, in that case, I'll route this one through percpu.

Thanks.

-- 
tejun
