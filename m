Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758318Ab0HKBuA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 21:50:00 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:59355 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757996Ab0HKBt6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 21:49:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=qfC7fjxqM4yu6o8AnGyWoxYht8OHlMltCS5F4TD8ybVfHukWAtl5TQIRxcV9RGg36z
         rMs/K/0AWKHoRgbCMxeyinAaN1mRhygYU1gqX/y7zXX+LG2QLAtAAmVBhmOcLYEj6XKV
         Z9XBu2C67icrgnd9xOAaLUTpz1PnMwhy08sBM=
MIME-Version: 1.0
In-Reply-To: <14414B36FFA0F1418CB707361EAA199A01987DD6@CNBEEXC006.nsn-intra.net>
References: <14414B36FFA0F1418CB707361EAA199A01987DD6@CNBEEXC006.nsn-intra.net>
Date: Wed, 11 Aug 2010 09:49:56 +0800
Message-ID: <AANLkTikmQAsBH3XfENY6+tT0AWK14TiePDF1-FgX0Fvc@mail.gmail.com>
Subject: Re: Compile one file in kernel
From: Xiaotian Feng <xtfeng@gmail.com>
To: "Zhang, Wei-Jovi (NSN - CN/Hangzhou)" <wei-jovi.zhang@nsn.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
