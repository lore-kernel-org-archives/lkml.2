Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753835Ab2HJMSm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2012 08:18:42 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:47293 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751177Ab2HJMSX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2012 08:18:23 -0400
MIME-Version: 1.0
In-Reply-To: <1344545594.25895.YahooMailNeo@web120102.mail.ne1.yahoo.com>
References: <1342922751.65328.YahooMailNeo@web120106.mail.ne1.yahoo.com>
	<CAJd=RBC24UXztNoKews5sE06DRvk_cBEYunHT7Zc-rdvAFF0ew@mail.gmail.com>
	<1343150934.42443.YahooMailNeo@web120104.mail.ne1.yahoo.com>
	<CAJd=RBCy+zy6jRWkpjPx43H=jqs37-L8Qij4Z5y9DYak2L643w@mail.gmail.com>
	<1344545594.25895.YahooMailNeo@web120102.mail.ne1.yahoo.com>
Date: Fri, 10 Aug 2012 20:18:22 +0800
Message-ID: <CAJd=RBA=gdh-9aSeNGSu=BMNgVAWOKNy_yL7sJPUUpyee5VBjQ@mail.gmail.com>
Subject: Re: Direct I/O bug in kernel
From: Hillf Danton <dhillf@gmail.com>
To: Victor Meyerson <calculuspenguin@yahoo.com>
Cc: "linux-mips@linux-mips.org" <linux-mips@linux-mips.org>,
        Ralf Baechle <ralf@linux-mips.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 10, 2012 at 4:53 AM, Victor Meyerson
<calculuspenguin@yahoo.com> wrote:
> I tried that patch, although I had to edit a slightly different line as dio_bio_alloc was near line 392 instead of 349 in the version of fs/direct-io.c in my tree.  I still got different checksums between the two files and even different checksums from my earlier attempts.
>
> I am not sure if this helps, but Ralf asked if I can try a different page size to see if this problem occurs.  I originally had CONFIG_PAGE_SIZE_4KB=y and changed it to CONFIG_PAGE_SIZE_16KB=y (via menuconfig).  Having a page size of 16KB (and the above patch not applied) made the checksum on the files match each other and match the file made from the working kernel.
>

Thanks for tests, Victor.

Please elaborate on the role of page size in this case, Ralf.

Good Weekend
Hillf
