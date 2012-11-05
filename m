Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753343Ab2KEIhD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 03:37:03 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:50036 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752782Ab2KEIhA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 03:37:00 -0500
X-AuditID: cbfee61b-b7f616d00000319b-41-50977aab5efa
Message-id: <50977AAE.4050101@samsung.com>
Date: Mon, 05 Nov 2012 17:37:02 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.2) Gecko/20120216
 Thunderbird/10.0.2
MIME-version: 1.0
To: Alexey Khoroshilov <khoroshilov@ispras.ru>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        ldv-project@linuxtesting.org
Subject: Re: [PATCH] extcon: arizona: unlock mutex on error path in
 arizona_micdet()
References: <1352060386-13610-1-git-send-email-khoroshilov@ispras.ru>
 <20121105080432.GB28886@opensource.wolfsonmicro.com>
In-reply-to: <20121105080432.GB28886@opensource.wolfsonmicro.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrMIsWRmVeSWpSXmKPExsVy+t8zPd3VVdMDDE4ckLa4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZL/Z8ZipYz1Jxffl6tgbGa8xdjJwcEgImEnsX3GeCsMUkLtxb
	z9bFyMUhJLCMUWLv4h5WmKLVL3ezQySmM0r0nl7MCuF0MUnsPDyDDaSKV0BL4uHPB0BjOThY
	BFQlHs8qAwmzAYX3v7jBBhIWFYiQ+NXPAVEtKPFj8j0WEFtEQE/i46utTCAjmQUOMUp8PrcK
	7DphgTCJrn197CC2kECNxL4nK8FsTgFHib7WZrC1zAI6Evtbp0HZ8hKb17wF62UREJD4NvkQ
	C8heCQFZiU0HmEHmSwg0s0sc2NDBBvGYpMTBFTdYJjCKzUJy0ywkY2chGbuAkXkVo2hqQXJB
	cVJ6rpFecWJucWleul5yfu4mRkhMSO9gXNVgcYhRgINRiYf3k8T0ACHWxLLiylygrziYlUR4
	ORiAQrwpiZVVqUX58UWlOanFhxh9gK6dyCwlmpwPjNe8knhDYwNjQ0NLQzNTS1MDHMJK4rzN
	HikBQgLpiSWp2ampBalFMOOYODilGhhnJf2KFSwpuOZe8uxz556yuff9RT943bJx+Hr7/0Hx
	H75e5pxfWYL67nJGn7hfn1hW5c29u3rXy3XhcxRj8vbv9T8rcPR6orua4DTjtPkFU29xWz4+
	4CXYa+zg+fLiSqY7+ofKFlQvWt+j4X3561KTV68Svj9q72z9u+OCV3/5O/mKqZ8cGU2UWIoz
	Eg21mIuKEwF2n6VwtgIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrEIsWRmVeSWpSXmKPExsVy+t9jQd3VVdMDDH6+F7G4vGsOmwOjx+dN
	cgGMUQ2MNhmpiSmpRQqpecn5KZl56bZK3sHxzvGmZgaGuoaWFuZKCnmJuam2Si4+AbpumTlA
	U5UUyhJzSoFCAYnFxUr6dpgmhIa46VrANEbo+oYEwfUYGaCBhHWMGS/2fGYqWM9ScX35erYG
	xmvMXYycHBICJhKrX+5mh7DFJC7cW8/WxcjFISQwnVGi9/RiVgini0li5+EZbCBVvAJaEg9/
	PgDq5uBgEVCVeDyrDCTMBhTe/+IGG0hYVCBC4lc/B0S1oMSPyfdYQGwRAT2Jj6+2MoGMZBY4
	xCjx+dwqsCOEBcIkuvb1gR0hJFAjse/JSjCbU8BRoq+1GWwts4COxP7WaVC2vMTmNW+ZJzAK
	zEKyYxaSsllIyhYwMq9iFE0tSC4oTkrPNdIrTswtLs1L10vOz93ECI64Z9I7GFc1WBxiFOBg
	VOLh/SQxPUCINbGsuDIX6EoOZiURXg4GoBBvSmJlVWpRfnxRaU5q8SFGH2AATGSWEk3OByaD
	vJJ4Q2MTMyNLIzNjE3NjYxzCSuK8zR4pAUIC6YklqdmpqQWpRTDjmDg4pRoYp522fv/L4+c9
	3TkqDqYiCttbJ/psT1r8S+by99lTb18vW/V4slNM9ov8uTvP2Bpoy7leWJ+YXqTq0tPhKhB6
	utJq0/rky8la1jX/ClzOTdpjtOn0UquNTw+syj348fqMRoXYJWcOXjH8oiMS/9cv3o/jWr65
	5NUDEo9rHyg6+4aErBFpeijkqcRSnJFoqMVcVJwIAIQFzNvlAgAA
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/05/2012 05:04 PM, Mark Brown wrote:
> On Sun, Nov 04, 2012 at 01:19:46PM -0700, Alexey Khoroshilov wrote:
>> If regmap_read() failed, arizona_micdet() returns IRQ_NONE
>> leaving &info->lock mutex locked as opposed to all other return paths.
>>
>> Found by Linux Driver Verification project (linuxtesting.org).
> 
> Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

Applied, thanks.

You can check this patch on extcon git tree:
- git://git.kernel.org/pub/scm/linux/kernel/git/chanwoo/extcon.git (for-next branch)

Chanwoo Choi
