Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755483Ab0KDI4K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 04:56:10 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:51072 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754003Ab0KDI4F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 04:56:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=nYfZ3rP+5uH9uPK7dT74xXKMqmaEDfBi3HvmKo1JVlMbsvuAh/tMFwDkcJ1Q9ke998
         GtPyo00YWddI70NIpgC9kLd7aRhT7gw/JbQGVwUPYFekZYFlMdgx6zpHTARAN29gXkDZ
         qQ0ZlDwqS6Lj/qi1aRDK15DVpk6sfkLnDmfLw=
Date: Thu, 4 Nov 2010 17:00:50 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: trapDoor <trapdoor6@gmail.com>
Cc: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Pure kernel '2.6.37-rc1-00001-ge99d11d' shown as ~-dirty after
 compilation
Message-ID: <20101104090050.GF5210@cr0.nay.redhat.com>
References: <AANLkTik=04z2thHBS3Z9n68QnTs=i8g8qTFtNT3jb8cg@mail.gmail.com>
 <20101103164840.GC4683@hack>
 <AANLkTi=1GdZVYr2z6P7PfR-VKREVzk__1ZodO2nu4dNY@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=1GdZVYr2z6P7PfR-VKREVzk__1ZodO2nu4dNY@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 03, 2010 at 05:07:00PM +0000, trapDoor wrote:
>>>
>>>So, what's this '-dirty' about?
>>>
>>
>> That means your git tree is not clean, since you placed new firmwares
>> into the source tree.
>>
>
>OK, but then 'make kernelrelease' should produce the same '..-dirty'
>version, not just '2.6.37-rc1-00001-ge99d11d', shouldn't it?
>

Yes, it should.

>I always do the following steps in the same order:
>1) first I place the firmware files in <kernel-src>/firmware/radeon
>2) then I choose appropriate config file and copy it into kernel
>source directory
>3) then I run 'make oldconfig' and at the end - just before compiling
>and installing - 'make kernelrelease'
>
>As I mentioned, for none of the kernels I compiled prior to this
>version (either from git or from tarball) 'make kernelrelease'
>produced different version name than it came up after compilation.
>

Note, there are few generated files not listed in gitignore, thus
could cause your tree not to clean. For those files, we should
add them into .gitignore.

Thanks.

