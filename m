Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751609Ab1A0GMm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 01:12:42 -0500
Received: from oproxy3-pub.bluehost.com ([69.89.21.8]:48944 "HELO
	oproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750835Ab1A0GMl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 01:12:41 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=coly.li;
	h=Received:Message-ID:Date:From:Reply-To:User-Agent:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=lAlecjYDdh7tcdXDTzKgk9Aqv9Oyq837LX1Bqp52pI9Kzm+j8BmYe1SjLQ8NzDUj6zV5dp71UCQWeVRCns6sbriyYxo500cDM7u1KYzXOL6RB5N6wpHCGozSFAHVoAa9;
Message-ID: <4D4112F1.70804@coly.li>
Date: Thu, 27 Jan 2011 14:38:41 +0800
From: Coly Li <i@coly.li>
Reply-To: i@coly.li
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; zh-CN; rv:1.9.2.13) Gecko/20101206 SUSE/3.1.7 Thunderbird/3.1.7
MIME-Version: 1.0
To: Yong Zhang <yong.zhang0@gmail.com>
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Greg KH <gregkh@suse.de>
Subject: Re: [PATCH 0/6] use BUG_ON correctly
References: <1296067193-15879-1-git-send-email-bosong.ly@taobao.com>	<AANLkTikq2YttapeLKkSeM-MrPoBdvPR32-oL6BdBOKdf@mail.gmail.com>	<4D410EF8.3070508@coly.li> <AANLkTi=NCoMNAnVrcs7D8xccK0928oG_W5Bp2sSVabWH@mail.gmail.com>
In-Reply-To: <AANLkTi=NCoMNAnVrcs7D8xccK0928oG_W5Bp2sSVabWH@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Identified-User: {1390:box585.bluehost.com:colyli:coly.li} {sentby:smtp auth 114.251.86.0 authed with i@coly.li}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011年01月27日 14:07, Yong Zhang Wrote:
> On Thu, Jan 27, 2011 at 2:21 PM, Coly Li<i@coly.li>  wrote:
>> On 2011年01月27日 10:02, Yong Zhang Wrote:
>>>
>>> On Thu, Jan 27, 2011 at 2:39 AM, Coly Li<bosong.ly@taobao.com>    wrote:
>>>>
>>>> BUG_ON() already uses unlikely() inside its definition if possible,
>>>
>>> It's true for asm-generic/bug.h.
>>>
>>> But for archs which has defined HAVE_ARCH_BUG,
>>> unlikely() is not always included in it.
>>>
>>
>> IMHO, if this condition happens, it should be a bug of the arch
>> implementation,
>
> So that means we should fix that first :)
>

Could you please to identify a piece of kernel code which provides an example as the condition you mentioned ?
So I can have a look firstly.

-- 
Coly Li
