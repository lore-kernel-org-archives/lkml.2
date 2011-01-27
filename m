Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751475Ab1A0GHG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 01:07:06 -0500
Received: from mail-yi0-f46.google.com ([209.85.218.46]:40206 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750952Ab1A0GHF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 01:07:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=fCXlnSeC3SmwNrMhJwJHhbe29VClSQVUfnHtEiiihaxLSUV96J2VWbOpO+EF10pMIB
         QYFzS18qEIG/wla8FdgR7z0aJujQ+RWomFoeN22RH7OwS9vDHOtU9/6WrcZmqC8nHGn4
         8TuxcET4dlYB0A3uEQuJs7BOivzmlytc/dvLI=
MIME-Version: 1.0
In-Reply-To: <4D410EF8.3070508@coly.li>
References: <1296067193-15879-1-git-send-email-bosong.ly@taobao.com>
	<AANLkTikq2YttapeLKkSeM-MrPoBdvPR32-oL6BdBOKdf@mail.gmail.com>
	<4D410EF8.3070508@coly.li>
Date: Thu, 27 Jan 2011 14:07:04 +0800
Message-ID: <AANLkTi=NCoMNAnVrcs7D8xccK0928oG_W5Bp2sSVabWH@mail.gmail.com>
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

On Thu, Jan 27, 2011 at 2:21 PM, Coly Li <i@coly.li> wrote:
> On 2011年01月27日 10:02, Yong Zhang Wrote:
>>
>> On Thu, Jan 27, 2011 at 2:39 AM, Coly Li<bosong.ly@taobao.com>  wrote:
>>>
>>> BUG_ON() already uses unlikely() inside its definition if possible,
>>
>> It's true for asm-generic/bug.h.
>>
>> But for archs which has defined HAVE_ARCH_BUG,
>> unlikely() is not always included in it.
>>
>
> IMHO, if this condition happens, it should be a bug of the arch
> implementation,

So that means we should fix that first :)

Thanks,
Yong

-- 
Only stand for myself
