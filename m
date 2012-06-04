Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760897Ab2FDQL0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 12:11:26 -0400
Received: from nm24-vm0.access.bullet.mail.mud.yahoo.com ([66.94.236.143]:20840
	"HELO nm24-vm0.access.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752297Ab2FDQLZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 12:11:25 -0400
X-Yahoo-Newman-Id: 351936.77985.bm@smtp102.biz.mail.ne1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: qFvH2qUVM1mirWmFF.MEMpNNdj7ztbqNM.aSEk1cZn8URZT
 ictYU5dtS6ILui7KJbEck6o3uVtenUA46CNk_qR.NyMKYRahRHpJZsnBWN0I
 66851.3cxfUnurRSJA3hJRajWt3eYokrEBRPiu2ttgGi4U5KQ0Chw60wqZRD
 yeT9.O3TDa_oL.AqBWcQ.uUHVBQUdl.0y.mX.MwNac7z8efaK1hAGfwcBGVO
 DMvk6Sfd0rtXFV0ruBX.vojD9Y3PYGXNc4lMgb8aJGUg7OWkvAlndqWwE_u2
 c2amzQ_otGXRpt0zOkL6DW016UqbvrRftQQxlzfkTzDbTT6MEmwmS6Agb4xI
 w7_rgBn.zt.OWQVKaxYF94XqRFPxFKZ6JJC31cipND6p3HBPD6_PtnV4CuuR
 1Pt9zAryBkH1_lVCRx3m6RE5Jl4678IxICrLloCUE3VDxzI0xijw.RAbx5s6
 6dW3cwM8q6FDKvxqIRKW7j7G3og--
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
Message-ID: <4FCCDE2B.3020306@schaufler-ca.com>
Date: Mon, 04 Jun 2012 09:11:23 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: George Shuklin <george.shuklin@gmail.com>
CC: Al Viro <viro@ZenIV.linux.org.uk>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: Why minor is still 8 bit?
References: <4FCC0E6D.9000206@gmail.com> <20120604013504.GU30000@ZenIV.linux.org.uk> <4FCC3151.1040503@gmail.com>
In-Reply-To: <4FCC3151.1040503@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/3/2012 8:53 PM, George Shuklin wrote:
>
> On 04.06.2012 05:35, Al Viro wrote:
>> On Mon, Jun 04, 2012 at 05:25:01AM +0400, George Shuklin wrote:
>>> I've understand that major and minor numbers for device is 8-bit size.
>>>
>>> I've don't understand, WHY? In 2012!
>>>
>>> (I've just have some discussion about 8-bit counter limitations in
>>> context of cloud computing. In middle of 2012!!!!)
>> Yes, shocking.  It's been several years and you are still using that
>> buzzword; I mean, it's _so_ 2010...  Should've moved on to whatever's
>> in this year...
>>
>> Incidentally, minors are 20 bit and majors are 12, but don't let that
>> stand in the way of righteous indignation - what's mere facts when
>> one is having discussions in context, presumably leveraging synergies
>> all along...
> Ok, thank you for information.
>
> But question is almost same: can I have 30k active logical volumes on
> my single server, please?

What are you trying to do, create a logical volume for every file?
There are at least three separate technologies available that will
solve whatever your problem is better than having 30,000 logical
volumes. I don't have a clue what you think you're trying to
accomplish and I am still willing to bet beers that you're bus is
parked solidly on the wrong tracks.


> -- 
> To unsubscribe from this list: send the line "unsubscribe
> linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

