Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751459Ab0HTGva (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 02:51:30 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:48968 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750984Ab0HTGv2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 02:51:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Mm75YviDfyUoTV2j/hqtNHJ1V+aBwmPeQsNgFbHvosktUn4L/mDVBx6kYs8dEekMvx
         9xlpk7ial2N1tBjAE5ECiQA74dW4mlLu3TTzrcN/MfrhMH+uOixQHadBWG+zBhXfth7K
         YVnrytehpbmd12+rHUAobt04+RRytLrigs+ws=
MIME-Version: 1.0
In-Reply-To: <AANLkTikEMfVE0FaT_se5H1yq7FOKi0gu8qbRMB0c8JKJ@mail.gmail.com>
References: <AANLkTikEMfVE0FaT_se5H1yq7FOKi0gu8qbRMB0c8JKJ@mail.gmail.com>
Date: Fri, 20 Aug 2010 08:51:27 +0200
Message-ID: <AANLkTiktWtAefkAWJNDnSx9SKf_hAOHqcHeEAXV0ARj3@mail.gmail.com>
Subject: Re: Using block layer's I/O context api (block/blk-ioc.c) without CFQ.
From: Corrado Zoccolo <czoccolo@gmail.com>
To: =?UTF-8?Q?Pedro_Eug=C3=AAnio_Rocha?= 
	<pedro.eugenio.rocha@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/8/19 Pedro Eugênio Rocha <pedro.eugenio.rocha@gmail.com>:
> Hi,
Hi,
>
> Is there a way to use the generic block layer I/O context api
> (block/blk-ioc.c), without
> using cfq specific functions and structs? I'm writing an I/O scheduler
> for my master
> thesis, and I'd like to use my own functions for I/O context handling,
> not cfq's. Sorry
> if I'm missing something here.
Sure. I think you can get an idea by grabbing an old enough kernel
that still has anticipatory scheduler (if I recall correctly, 2.6.32
should have it), and look at its functions.
Or you can look at my post:
http://lists.openwall.net/linux-kernel/2009/06/08/387, where I
implemented a proof-of-concept I/O scheduler based on anticipatory
scheduler. Most of the concepts in that scheduler were later ported to
CFQ.
Do you already have a scheduling algorithm in mind? And what will be
your main purpose/target?

Thanks
Corrado
>
> Thanks,
>
> Pedro Eugênio Rocha
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>



-- 
__________________________________________________________________________

dott. Corrado Zoccolo                          mailto:czoccolo@gmail.com
PhD - Department of Computer Science - University of Pisa, Italy
--------------------------------------------------------------------------
The self-confidence of a warrior is not the self-confidence of the average
man. The average man seeks certainty in the eyes of the onlooker and calls
that self-confidence. The warrior seeks impeccability in his own eyes and
calls that humbleness.
                               Tales of Power - C. Castaneda
