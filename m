Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754082Ab1CQLqh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 07:46:37 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:55127 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752910Ab1CQLqe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 07:46:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=LAVSPWyawAMKeQiLxnSNcxBMq382uaZJubH0H1NOFrMNwaQIPv3VT8YnrWOy1GdkKj
         AKPfOUzs7jf1FxzyCLE/sqmecJAlDs5ysXq0rLnLodGARwuGikzXrnmyzjcjN4JRmo2N
         3nBc/qx1iDAWWEy1Nx5rhpZ0tkghPgf9d5k5E=
MIME-Version: 1.0
In-Reply-To: <4D80C47C.80300@draigBrady.com>
References: <AANLkTik3N5j74eWastminNZLevPqoSCEiVCrX1vP66_k@mail.gmail.com>
 <20110315091412.de6eb63c.rdunlap@xenotime.net> <AANLkTikU_kPOoNv6gJiPOsmrkFDddTLQ-0--wViYyFxj@mail.gmail.com>
 <4D80C47C.80300@draigBrady.com>
From: Aneesh Bhasin <contact.aneesh@gmail.com>
Date: Thu, 17 Mar 2011 17:16:13 +0530
Message-ID: <AANLkTi=gN=DOU9bQtqdr1s44y5QgLn0W9_oRb9JTMWNa@mail.gmail.com>
Subject: Re: smap output - unnamed entries and heap
To: =?ISO-8859-1?Q?P=E1draig_Brady?= <P@draigbrady.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>,
        linux-newbie <linux-newbie@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/3/16 Pádraig Brady <P@draigbrady.com>:
> On 16/03/11 05:19, Aneesh Bhasin wrote:
>> Also, is there a way in linux (without using
>> dedicated tools like valgrind), to see how much heap or anonymous
>> memory is attributed to code arising from a particular library/binary
>
> You might find ps_mem.py useful.
> If parses smaps and reports RAM usage of a program
>
> http://www.pixelbeat.org/scripts/ps_mem.py
>
> cheers,
> Pádraig.

I did try that script. Unfortunately, I not only want the memory used
for my program but also, which library is contributing to that memory.
To that end, I have written a small script which parses the smap
output in a format more suitable for my analysis.

However, as I wrote earlier, there a lot of anonymous memory regions
listed in smap output (with permission rwxp) - and I do not know of
any way in which I could associate these memory mapping to a
particular library..

Any pointers in this regard will be highly appreciated :)

Regards,
Aneesh
