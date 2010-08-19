Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753421Ab0HSN7f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 09:59:35 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:54030 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753399Ab0HSN7c convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 09:59:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=QTOk9PtIqRz4w/iv9IdHksihTZOEy4nm+QujCwmptn2uylLAHp23NL9sCcXqmcNC6M
         E8r/LAA7cV0WVClYtXAKedxMRHKUZcKihz+lcze1BV8dt0l/FMK1mRlX69fHwKUBeDhS
         q85Mpngzf/pSwCOYvfJ/GZW+v3oxz2gy2+sTY=
MIME-Version: 1.0
In-Reply-To: <20100818172627.7e38969f@varda>
References: <20100818151857.GA6188@barrios-desktop>
	<20100818172627.7e38969f@varda>
Date: Thu, 19 Aug 2010 09:54:49 +0900
Message-ID: <AANLkTimxbJQ7+cJ20x1Bcm=1xk_JgMANUQDFn-pJ9jZa@mail.gmail.com>
Subject: Re: android-kernel memory reclaim x20 boost?
From: Minchan Kim <minchan.kim@gmail.com>
To: =?ISO-8859-1?Q?Alejandro_Riveira_Fern=E1ndez?= <ariveira@gmail.com>
Cc: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>,
        swetland@google.com, linux-kernel <linux-kernel@vger.kernel.org>,
        linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 19, 2010 at 12:26 AM, Alejandro Riveira Fernández
<ariveira@gmail.com> wrote:
> El Thu, 19 Aug 2010 00:18:57 +0900
> Minchan Kim <minchan.kim@gmail.com> escribió:
>
>> Hello Android forks,
> [ ... ]
>>
>> I saw the advertisement phrase in this[1].
>>
>> "Kernel Memory Management Boost: Improved memory reclaim by up to 20x,
>> which results in faster app switching and smoother performance
>> on memory-constrained devices."
>>
>> But I can't find any code for it in android kernel git tree.
>
>  Maybe the enhancements are on the Dalvik VM (shooting in the dark here)

Thanks.
Android guys! Could you confirm this?


-- 
Kind regards,
Minchan Kim
