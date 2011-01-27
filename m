Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751411Ab1A0GUO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 01:20:14 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:46642 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750866Ab1A0GUM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 01:20:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=V1ZxvVi/RDuwlDe+wK9BsgAlBYsQ73XDD/Sn4o6ea6ZlBIue2nLjDsbItuLZWqCS3M
         xVDDOdsPGQO8//0Ya1Csh6X3IBlS/bdpWKK2wPEGzVvg+HVGE8aamvjWG/spsNBpGApd
         gTk24RelQdW+xLKni2TDOtxfZAee1Z89pU8wk=
MIME-Version: 1.0
In-Reply-To: <4D4112F1.70804@coly.li>
References: <1296067193-15879-1-git-send-email-bosong.ly@taobao.com>
	<AANLkTikq2YttapeLKkSeM-MrPoBdvPR32-oL6BdBOKdf@mail.gmail.com>
	<4D410EF8.3070508@coly.li>
	<AANLkTi=NCoMNAnVrcs7D8xccK0928oG_W5Bp2sSVabWH@mail.gmail.com>
	<4D4112F1.70804@coly.li>
Date: Thu, 27 Jan 2011 14:20:11 +0800
Message-ID: <AANLkTikPtCL++c47vPCzqBh_veG+fzZWR2w2xAYDUgw=@mail.gmail.com>
Subject: Re: [PATCH 0/6] use BUG_ON correctly
From: Yong Zhang <yong.zhang0@gmail.com>
To: i@coly.li
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Greg KH <gregkh@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 27, 2011 at 2:38 PM, Coly Li <i@coly.li> wrote:
> On 2011年01月27日 14:07, Yong Zhang Wrote:
>>
>> On Thu, Jan 27, 2011 at 2:21 PM, Coly Li<i@coly.li>  wrote:
>>>
>>> On 2011年01月27日 10:02, Yong Zhang Wrote:
>>>>
>>>> On Thu, Jan 27, 2011 at 2:39 AM, Coly Li<bosong.ly@taobao.com>    wrote:
>>>>>
>>>>> BUG_ON() already uses unlikely() inside its definition if possible,
>>>>
>>>> It's true for asm-generic/bug.h.
>>>>
>>>> But for archs which has defined HAVE_ARCH_BUG,
>>>> unlikely() is not always included in it.
>>>>
>>>
>>> IMHO, if this condition happens, it should be a bug of the arch
>>> implementation,
>>
>> So that means we should fix that first :)
>>
>
> Could you please to identify a piece of kernel code which provides an
> example as the condition you mentioned ?
> So I can have a look firstly.

   #   line  filename / context / line
   1     35  arch/mips/include/asm/bug.h <<HAVE_ARCH_BUG_ON>>
             #define HAVE_ARCH_BUG_ON
   2    115  arch/powerpc/include/asm/bug.h <<HAVE_ARCH_BUG_ON>>
             #define HAVE_ARCH_BUG_ON

Thanks,
Yong


-- 
Only stand for myself
