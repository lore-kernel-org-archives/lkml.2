Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753595Ab0GLGJv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 02:09:51 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:56800 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751326Ab0GLGJu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 02:09:50 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 12 Jul 2010 15:05:14 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: "Noah McNallie" <n0ah@n0ah.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: any current public code to limit memory per user?
Message-Id: <20100712150514.6151ad45.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <op.vfpu2vvelgimzx@win7>
References: <op.vfpu2vvelgimzx@win7>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Jul 2010 02:02:45 -0400
"Noah McNallie" <n0ah@n0ah.org> wrote:

> As the topic says :o)
> 
> To be more precise, is there any public patch or somewhat that can help  
> with this? As far as i know, in linux, it is only possible to limit memory  
> per process. Correct me if i'm wrong.
> 
> noah

Documentation/cgroups/memory.txt

For per UID limit, please see http://libcg.sourceforge.net/

Thanks,
-Kame

