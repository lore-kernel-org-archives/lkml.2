Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757340Ab1KOTeq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 14:34:46 -0500
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:40095 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756356Ab1KOTep (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 14:34:45 -0500
Message-ID: <4EC2BED2.3000707@linux.vnet.ibm.com>
Date: Wed, 16 Nov 2011 01:04:42 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: dienet <dienet@poczta.fm>
CC: linux-acpi@vger.kernel.org,
        Linux PM mailing list <linux-pm@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Resuming from hibernation on T61 with nvidia
References: <op.v4z4ihs2wcw97g@localhost>
In-Reply-To: <op.v4z4ihs2wcw97g@localhost>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/16/2011 12:32 AM, dienet wrote:
> Hello
> 
> As far I can remember (since I have my ThinkPad T61), there is problem 
> with resuming from hibernation (suspend-to-disk) on this system. And I 
> know that there are lots of people with the same problem.
> I was checking lots of kernel versions but with no luck.
> 
> Was is the problem? In my T61 I have 01:00.0 VGA compatible controller: 
> nVidia Corporation G84M [Quadro NVS 140M] (rev a1) and I am using
> nvidia  drivers (also checked quite a few versions without any luck).
> Suspending  to disk is working without any problem. The problem is when
> I want to  resume. The resume process is stopping at some point (I think
> after the  pages are red) for about 60 seconds. After that time, the
> resume process  is continuing, and after few sec, I am back in X11.
> 
> I have motivation to fix it, but:
> 
> 1. How to trace it?
> 2. Is it possible to fix this? Maybe the fix should take place in
> nvidia  driver (nvidia.o), and that can not be done. But maybe the fix
> can be done  in kernel?
> 
> I want to notice that, if the fix will only work for me, then that is
> fine  with me.
> 
> I know that answer to 2. might be hard, so maybe some guide how to
> trace  the problem?
> 

Hi,

[Adding linux-pm and linux-kernel mailing lists to CC.]

You can try using the pm_test framework for debugging this, to a certain
extent. See Documentation/power/basic-pm-debugging.txt for details on how
to use it.

Also, if you could post any logs that indicate the problem, that would
be great!

Thanks,
Srivatsa S. Bhat
