Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752691Ab1DHFgc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 01:36:32 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:40820 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751418Ab1DHFgb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 01:36:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=eSDpCMCaE17waRCnqP4Q91hUCETup/I6cMdK4LLH18cSVnIVF2QiC9Jcg5n2G60nTg
         qa1mvsDSAbW0KoPR2OxZZh9RF3Au3yfhFc+okMwTUNOA4zudrQO6nRqvlAs1/q0MbItb
         sGVOEysZ94kGYg2dAyhn8erUN9qHorazYIGg0=
MIME-Version: 1.0
In-Reply-To: <1302077959.2225.1378.camel@twins>
References: <BANLkTin7=j8-feeJw5fqDsMd9BYrq09KbQ@mail.gmail.com>
 <1302024458.2225.1350.camel@twins> <BANLkTinU5s8FgC9acCPcQqDRBnwi4EqA2g@mail.gmail.com>
 <1302077959.2225.1378.camel@twins>
From: Hui Zhu <teawater@gmail.com>
Date: Fri, 8 Apr 2011 13:36:11 +0800
Message-ID: <BANLkTimHwt=q4K9uMNX4kR6Q8LJhHHSysw@mail.gmail.com>
Subject: Re: KGTP (Linux Kernel debugger and tracer) 20110405 release
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, Marc Khouzam <marc.khouzam@ericsson.com>,
        Thiago Jung Bauermann <thiago.bauermann@gmail.com>,
        Steven <mqyoung@gmail.com>, colyli@gmail.com,
        Christoph Hellwig <hch@infradead.org>,
        Jason Wessel <jason.wessel@windriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 6, 2011 at 16:19, Peter Zijlstra <peterz@infradead.org> wrote:
> On Wed, 2011-04-06 at 13:54 +0800, Hui Zhu wrote:
>
>> This is a good question.
>>
>> The KGTP is completely different with KGDB.  It will not supply simple
>> gdbrsp debug interface to user.  It just supply  interface between the
>> kernel tracepoint(Now, just support kprobe, will add others later) and
>> GDB tracepoint function.
>>
>> So user can debug and trace Linux kernel with GDB without stop the
>> Linux Kernel (So the GDB can running on this Kernel).  It is a trace
>> tools and debug tools.
>
> But this isn't really an answer either. Could you extend the existing
> KGDB infrastructure to provide these features and thereby re-use
> existing infrastructure to reduce your patch size and code duplication?
>
> Jason (the KGDB maintainer) certainly thought there was much possibility
> there when I spoke to him yesterday.
>
> Think of it this way, wouldn't it be much better if there was one tool
> that could provide the combined feature set of KGDB and KGTP?
>

Thanks Peter.  I think it is very good.

Which part do you think kgtp can share with kgdb?

Thanks,
Hui
