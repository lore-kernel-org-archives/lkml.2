Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754945Ab1EBQdU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 12:33:20 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:23986 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751415Ab1EBQdT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 12:33:19 -0400
Date: Mon, 2 May 2011 09:32:44 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Harry Wei <jiaweiwei.xiyou@gmail.com>
Cc: linux-kernel@vger.kernel.org, trivial@kernel.org, randy.dunlap@oracle.com,
        greg@kroah.com, joe@perches.com, akpm@linux-foundation.org
Subject: Re: [Oops 2/2]The frame size of xxx bytes is larger than 1024 bytes
Message-Id: <20110502093244.7594a929.randy.dunlap@oracle.com>
In-Reply-To: <20110430062222.GB4274@gmail.com>
References: <20110430062222.GB4274@gmail.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: rcsinet15.oracle.com [148.87.113.117]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4DBEDCB3.0008:SCFMA4539811,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 30 Apr 2011 14:22:24 +0800 Harry Wei wrote:

> Hi us,
> 	A warning disturbs me for a long time.
> It shows like following.
> 
> [...]
> Warning: the frame size of xxx bytes is larger than 1024 bytes.
> [...]
> 
> See http://s1202.photobucket.com/albums/bb364/harrywei/Kernel/?action=view&current=report_bug1.png for details.
> 	Of course, i wanna fix it. But i have no ways.
> Can anyone do me a favor?

Hi Harry,

It looks like drivers/staging/rt28[67]0/ has all been removed, so no need to fix
these warnings.  However, there are other frame size warnings still in the kernel
tree if you want to fix them.

Also it would be better just to insert the warnings in your email instead of
posting a photo of them.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
