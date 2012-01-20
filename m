Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752710Ab2ATLNB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 06:13:01 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:34578 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752439Ab2ATLM4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 06:12:56 -0500
MIME-Version: 1.0
In-Reply-To: <20120118185457.GH3356@mwanda>
References: <1326856764-2531-1-git-send-email-pradheep.sh@gmail.com>
	<20120118065620.GE3294@mwanda>
	<CANz8tm1imZ3njy_uV0tkq0sXwyB5ZLLJsrp4G1zjcBDnJUrjiw@mail.gmail.com>
	<20120118185457.GH3356@mwanda>
Date: Fri, 20 Jan 2012 11:12:55 +0000
X-Google-Sender-Auth: 4h8MVfpziOSDaH1GXNc6wXc-4ns
Message-ID: <CAAq6er0OPkvTCLt1DvHSjyqM4pH7GMb-D78M09cJY+1ZV3miiQ@mail.gmail.com>
Subject: Re: [PATCH 1/6] staging:android_pmem.h: Fixes the space and other
 formating issues pointed out by checkpatch.pl
From: Andy Whitcroft <apw@canonical.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Pradheep Shrinivasan <pradheep.sh@gmail.com>, greg@kroah.com,
        devel@linuxdriverproject.org, swetland@google.com,
        linux-kernel@vger.kernel.org, Andy Whitcroft <apw@canonical.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 18, 2012 at 6:54 PM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> On Wed, Jan 18, 2012 at 11:38:34PM +0530, Pradheep Shrinivasan wrote:
>>> > > -#define PMEM_IOCTL_MAGIC 'p'
>> > > +#define PMEM_IOCTL_MAGIC ('p')
>> >
>> > You don't need parenthesis here.  Did checkpatch really complain
>> > about this?
>>
>> Yes the check patch does complain about the parenthesis.
>>
>> pradheep@ubuntu:~/linux-next/
>> linux-next/drivers/staging/android$ checkpatch android_pmem.h
>> android_pmem.h:10: ERROR: trailing whitespace
>> android_pmem.h:19: ERROR: Macros with complex values should be enclosed in
>> parenthesis
>
> That seems like a bug in checkpatch.pl.  It's hard to imagine less
> complex macro than:  #define PMEM_IOCTL_MAGIC 'p'

I can think of no way in which an unprotected character is different
to an unprotected integer constant.  So ...

Does the version here work better for you:

    http://people.canonical.com/~apw/checkpatch/checkpatch-next.pl

-apw
