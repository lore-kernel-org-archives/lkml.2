Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754503Ab1JJTCZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 15:02:25 -0400
Received: from oproxy6-pub.bluehost.com ([67.222.54.6]:53860 "HELO
	oproxy6-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754436Ab1JJTCW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 15:02:22 -0400
Message-ID: <4E93413C.5000702@xenotime.net>
Date: Mon, 10 Oct 2011 12:02:20 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.22) Gecko/20110907 SUSE/3.1.14 Thunderbird/3.1.14
MIME-Version: 1.0
To: Mike Marciniszyn <mike.marciniszyn@qlogic.com>
CC: Roland Dreier <roland@purestorage.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Dept_Infinipath <Dept_Infinipath@qlogic.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH -next] infiniband: fix ipath_chip_init.c build errors
References: <20111007174230.702f4a0bf1fe71dab5e10961@canb.auug.org.au> <4E8F683D.9020604@xenotime.net> <CAL1RGDXoiRfR1Ku67tRgbhxzyWQmDrjKCztnVd6wbwi0Uud90Q@mail.gmail.com> <35AAF1E4A771E142979F27B51793A48888433C0838@AVEXMB1.qlogic.org>
In-Reply-To: <35AAF1E4A771E142979F27B51793A48888433C0838@AVEXMB1.qlogic.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/10/11 11:57, Mike Marciniszyn wrote:
> As do I.
> 
> I've confirmed that patch does no harm, but I would like to see the error.
> 
> Which of the github repos exposes the error?

I saw it in linux-next of 20111007.


> Mike
> 
>> -----Original Message-----
>> From: Roland Dreier [mailto:roland@purestorage.com]
>> Sent: Friday, October 07, 2011 5:21 PM
>> To: Randy Dunlap
>> Cc: Stephen Rothwell; linux-next@vger.kernel.org; linux-kernel;
>> Dept_Infinipath; linux-rdma@vger.kernel.org; Andrew Morton
>> Subject: Re: [PATCH -next] infiniband: fix ipath_chip_init.c build
>> errors
>>
>> On Fri, Oct 7, 2011 at 1:59 PM, Randy Dunlap <rdunlap@xenotime.net>
>> wrote:
>>> Add <linux/stat.h> to fix build errors:
>>
>> When did this break?  I build ipath in my test config all the time...
>>
>>  - R.


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
