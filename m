Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934013Ab2JLM55 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 08:57:57 -0400
Received: from mail.avalus.com ([89.16.176.221]:59504 "EHLO mail.avalus.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933817Ab2JLM5z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 08:57:55 -0400
Date: Fri, 12 Oct 2012 13:57:50 +0100
From: Alex Bligh <alex@alex.org.uk>
Reply-To: Alex Bligh <alex@alex.org.uk>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: linux-kernel@vger.kernel.org, Alex Bligh <alex@alex.org.uk>
Subject: Re: Local DoS through write heavy I/O on CFQ & Deadline
Message-ID: <D436B65FA628E01BCB9A9318@nimrod.local>
In-Reply-To: <20121011144634.7017e270@pyramind.ukuu.org.uk>
References: <0B138F62-16BF-4295-9AD9-64C0BB39FCE2@alex.org.uk>
 <20121011144634.7017e270@pyramind.ukuu.org.uk>
X-Mailer: Mulberry/4.0.8 (Mac OS X)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan,

--On 11 October 2012 14:46:34 +0100 Alan Cox <alan@lxorguk.ukuu.org.uk> 
wrote:

>> We have reproduced this on multiple hardware environments, using 3.2
>> (/proc/version_signature gives "Ubuntu 3.2.0-29.46-generic 3.2.24").
>> Anecdotally we believe the situation has worsened since 3.0.
>
> I've certainly seen this on 3.0 and 3.2, but do you still see it on
> 3.5/6 ?

We've just tested this. We see exactly the same issue on 3.6.1 using
the current build of the Ubuntu Quantal kernel, which is:

Linux version 3.6.1-030601-generic (apw@gomeisa) (gcc version 4.6.3 
(Ubuntu/Linaro 4.6.3-1ubuntu5) ) #201210071322 SMP Sun Oct 7 17:23:28 UTC 
2012

More details (including full logs for that kernel) at:

 https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1064521

-- 
Alex Bligh
