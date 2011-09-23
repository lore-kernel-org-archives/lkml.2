Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751796Ab1IWD01 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 23:26:27 -0400
Received: from one.firstfloor.org ([213.235.205.2]:46514 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751228Ab1IWD0Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 23:26:25 -0400
Date: Fri, 23 Sep 2011 05:26:22 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Stephane Eranian <eranian@google.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        acme@redhat.com, peterz@infradead.org, mingo@elte.hu,
        dsahern@gmail.com, robert.richter@amd.com
Subject: Re: [PATCH] perf: make perf.data more self-descriptive (v5)
Message-ID: <20110923032622.GS7761@one.firstfloor.org>
References: <20110922123128.GA9761@quad> <m2pqisjmtw.fsf@firstfloor.org> <CABPqkBTPF0Tqj5BEWanuh5=VYWjY_NuSLx1gAjPr3o1sbJB-JQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBTPF0Tqj5BEWanuh5=VYWjY_NuSLx1gAjPr3o1sbJB-JQ@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  * .byte 0x53 == push ebx. it's universal for 32 and 64 bit
>  * .byte 0x5b == pop ebx.
>  * Some gcc's (4.1.2 on Core2) object to pairing push/pop and ebx in
> 64 bit mode.

What do you mean with "object" ? 

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
