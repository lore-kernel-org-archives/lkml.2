Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751543Ab0ENDTS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 23:19:18 -0400
Received: from mail-pz0-f204.google.com ([209.85.222.204]:53563 "EHLO
	mail-pz0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753775Ab0ENDTO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 23:19:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=r5s4MRJwWfz4rS0wHtolho5uAcBO19d/OMuSXk/H0PMIfExJPjt5T8iP/zTq2qK0Tf
         0uEtdIQ+ZPT5O+raYlvhLK1U5Xml2WdM4bJDWJRoYCV2t2uiADGT1SKuYDFNz7TdpDJc
         cntRsInEsm94bXx2HDMJFf6C9uU68Rlni6H6g=
MIME-Version: 1.0
In-Reply-To: <AANLkTimKHkgWJJOOICzQ4TL3mbL-lvYEocwBSe3XSBVR@mail.gmail.com>
References: <AANLkTimKHkgWJJOOICzQ4TL3mbL-lvYEocwBSe3XSBVR@mail.gmail.com>
Date: Fri, 14 May 2010 07:19:12 +0400
Message-ID: <AANLkTiktLXqHhop21ePIXF2kaVQbm3DIHZpLrEQOMA1e@mail.gmail.com>
Subject: Re: Performance Events hangs with Intel P4 system
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, May 14, 2010, Jaswinder Singh Rajput
<jaswinderlinux@gmail.com> wrote:
> Hello,
>
> I am testing Performance Events on P4 with HT:
>
> [    0.002243] Performance Events: Netburst events, Netburst P4/Xeon PMU driver.
> [    0.002432] ... version:                0
> [    0.002545] ... bit width:              40
> [    0.002659] ... generic registers:      18
> [    0.002772] ... value mask:             000000ffffffffff
> [    0.002887] ... max period:             0000007fffffffff
> [    0.003004] ... fixed-purpose events:   0
> [    0.003118] ... event mask:             000000000003ffff
>
> dmesg : http://userweb.kernel.org/~jaswinder/P4_HT/dmesg-2634-rc7-tip.txt
> config : http://userweb.kernel.org/~jaswinder/P4_HT/config-2634-rc7-tip.txt
>
> [jaswinder@ht perf]$ ./perf stat -e cycles ls > /dev/null
>
>  Performance counter stats for 'ls':
>
>   <not counted>  cycles
>
>     0.003447053  seconds time elapsed
>
> [jaswinder@ht perf]$ ./perf stat -e cycles,instructions ls > /dev/null
>
>  Performance counter stats for 'ls':
>
>   <not counted>  cycles
>         1862188  instructions             #      0.000 IPC    (scaled
> from 54.91%)
>
>     0.003419230  seconds time elapsed
>
> [jaswinder@ht perf]$ ./perf stat -e
> cycles,instructions,cache-references ls > /dev/null
>
> <<this dumps on screen and hangs the systems>>
>
> How can I fix this problem.
>
> Thanks,
> --
> Jaswinder Singh.
>

thanks for testing. Is there any issue in dmesg for first two perf
calls before it hangs? And is there a chance for screen dump (photo or
netconsole)?
