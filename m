Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933073Ab1EMNbd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 09:31:33 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:51069 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933041Ab1EMNbb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 09:31:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=eJrzGoxxdX9HxVABU6lVi07jmXFM5PnvnR6y4+4J0T8vKkjLI7s13EGQxJxGhXUtSf
         9kYu09fq1QlWB0pybaQFp9yEwtwBGeBDbezzFCPS19omX/z5x97fOEoQgKM0MDrnF2rB
         JG0LLi4sarSN0vUgaVLqXWWL/FMEOZHr2Wxls=
MIME-Version: 1.0
In-Reply-To: <20110512161914.e16be4d3.randy.dunlap@oracle.com>
References: <20110512142303.8117a0b6.sfr@canb.auug.org.au>
	<20110512161914.e16be4d3.randy.dunlap@oracle.com>
Date: Fri, 13 May 2011 15:31:30 +0200
Message-ID: <BANLkTin4+TiW=ejBKHMeF3o1K98HpUX8Hg@mail.gmail.com>
Subject: Re: linux-next: Tree for May 12 (ssb)
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-wireless@vger.kernel.org,
        linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Michael Buesch <mb@bu3sch.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/5/13 Randy Dunlap <randy.dunlap@oracle.com>:
> On Thu, 12 May 2011 14:23:03 +1000 Stephen Rothwell wrote:
>
>> Hi all,
>>
>> Changes since 20110511:
>
>
> on i386 and x86_64 (many randconfigs fail with these errors):
>
> drivers/ssb/main.c:1336: error: 'SSB_PCICORE_BCAST_ADDR' undeclared (first use in this function)
> drivers/ssb/main.c:1337: error: 'SSB_PCICORE_BCAST_DATA' undeclared (first use in this function)
> drivers/ssb/main.c:1349: error: 'struct ssb_pcicore' has no member named 'dev'

Whoops, I'm sorry. I'll check this today late night. I'm quite sure I
tested it, I don't know what does it happen.

-- 
Rafał
