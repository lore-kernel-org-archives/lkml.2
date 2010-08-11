Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750982Ab0HKEJu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 00:09:50 -0400
Received: from demumfd002.nsn-inter.net ([93.183.12.31]:10137 "EHLO
	demumfd002.nsn-inter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1749667Ab0HKEJs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 00:09:48 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Subject: RE: Compile one file in kernel
Date: Wed, 11 Aug 2010 12:09:34 +0800
Message-ID: <14414B36FFA0F1418CB707361EAA199A01988001@CNBEEXC006.nsn-intra.net>
In-Reply-To: <201008110402.o7B42PX5027191@demumfd001.nsn-inter.net>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Compile one file in kernel
Thread-Index: Acs49sbh+rlQArrYTbS+IPGJPnVblAAE6CvwAAAS9VA=
References: <AANLkTikmQAsBH3XfENY6+tT0AWK14TiePDF1-FgX0Fvc@mail.gmail.com> <201008110402.o7B42PX5027191@demumfd001.nsn-inter.net>
From: "Zhang, Wei-Jovi (NSN - CN/Hangzhou)" <wei-jovi.zhang@nsn.com>
To: "ext zhanglx" <zhanglx@semico.com.cn>, "Xiaotian Feng" <xtfeng@gmail.com>
Cc: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 11 Aug 2010 04:09:37.0786 (UTC) FILETIME=[039745A0:01CB390B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Apparently not, you should run "rm -f <filename>.o" firstly, then "make <filename>.o"
Maybe you can write a script to do this if you want to.

-----Original Message-----
From: ext zhanglx [mailto:zhanglx@semico.com.cn] 
Sent: Wednesday, August 11, 2010 12:07 PM
To: 'Xiaotian Feng'; Zhang, Wei-Jovi (NSN - CN/Hangzhou)
Cc: linux-kernel@vger.kernel.org
Subject: RE: Compile one file in kernel

If .o file is not cleaned, make will automatically select the changed files
to compile and link?

-----Original Message-----
From: linux-kernel-owner@vger.kernel.org
[mailto:linux-kernel-owner@vger.kernel.org] On Behalf Of Xiaotian Feng
Sent: Wednesday, August 11, 2010 9:50 AM
To: Zhang, Wei-Jovi (NSN - CN/Hangzhou)
Cc: linux-kernel@vger.kernel.org
Subject: Re: Compile one file in kernel

On Wed, Aug 11, 2010 at 8:59 AM, Zhang, Wei-Jovi (NSN - CN/Hangzhou)
<wei-jovi.zhang@nsn.com> wrote:
> Hi,
>        I always using command make, then it will compile all files. How
> about just compile one c file(just make sure some modify can compile
> successful), how should I do? Is there any command to allow me to doing
> this?

make <filename>.o

>        Thanks.
> .jovi
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
--
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/

