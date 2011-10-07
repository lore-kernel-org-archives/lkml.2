Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758951Ab1JGWSt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 18:18:49 -0400
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:44119 "HELO
	oproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758624Ab1JGWSs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 18:18:48 -0400
Message-ID: <4E8F77B8.3000805@xenotime.net>
Date: Fri, 07 Oct 2011 15:05:44 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.22) Gecko/20110907 SUSE/3.1.14 Thunderbird/3.1.14
MIME-Version: 1.0
To: Roland Dreier <roland@purestorage.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Mike Marciniszyn <infinipath@qlogic.com>, linux-rdma@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH -next] infiniband: fix ipath_chip_init.c build errors
References: <20111007174230.702f4a0bf1fe71dab5e10961@canb.auug.org.au> <4E8F683D.9020604@xenotime.net> <CAL1RGDXoiRfR1Ku67tRgbhxzyWQmDrjKCztnVd6wbwi0Uud90Q@mail.gmail.com>
In-Reply-To: <CAL1RGDXoiRfR1Ku67tRgbhxzyWQmDrjKCztnVd6wbwi0Uud90Q@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/07/11 14:21, Roland Dreier wrote:
> On Fri, Oct 7, 2011 at 1:59 PM, Randy Dunlap <rdunlap@xenotime.net> wrote:
>> Add <linux/stat.h> to fix build errors:
> 
> When did this break?  I build ipath in my test config all the time...

First I saw it was in today's linux-next (20111007).

-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
