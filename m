Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751939Ab2H1Xbf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2012 19:31:35 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:52233 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750807Ab2H1Xbe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2012 19:31:34 -0400
X-AuditID: cbfee61a-b7fc66d0000043b7-fe-503d54d5df08
Message-id: <503D54D6.6050706@samsung.com>
Date: Wed, 29 Aug 2012 08:31:34 +0900
From: Joonyoung Shim <jy0922.shim@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:14.0) Gecko/20120714
 Thunderbird/14.0
MIME-version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, kyungmin.park@samsung.com,
        yadi.brar@samsung.com, jonghwa3.lee@samsung.com
Subject: Re: [PATCH] regulator: max77686: add of_node assignment
References: <1346153130-29038-1-git-send-email-jy0922.shim@samsung.com>
 <20120828171618.GF4534@opensource.wolfsonmicro.com>
In-reply-to: <20120828171618.GF4534@opensource.wolfsonmicro.com>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrBLMWRmVeSWpSXmKPExsVy+t9jQd2rIbYBBlvvcFlc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6Mia8msBR8ZK741NnG2sA4k7mLkZNDQsBE4vTOP4wQtpjEhXvr
	2boYuTiEBKYzSlzo72KBcLqYJLpO/GUDqeIV0JJYtfYaK4jNIqAq0ft0DVicTUBP4s6240wg
	tqhAiMT1PRsYIeoFJX5Mvgc0iINDBGjb7/uVIGFmgTyJ2xd6WEBsYQEHiRWTXoGNERKolfgw
	awEjSDknUPzAc3aIcmuJlZO2MULY8hKb17xlnsAoMAvJgllIymYhKVvAyLyKUTS1ILmgOCk9
	11CvODG3uDQvXS85P3cTIzj8nkntYFzZYHGIUYCDUYmH9wK3bYAQa2JZcWXuIUYJDmYlEd6n
	pkAh3pTEyqrUovz4otKc1OJDjNIcLErivPx9hgFCAumJJanZqakFqUUwWSYOTqkGRoZJO7Yd
	+nMtfm7z54eKpVIObtfvMNcf78g71vfc5PX7kCd93sVPWcRfHNbyd511JqfL4rinhlO7U3RG
	7YIfiw/xrgpYVL7xo7J11ov7Wt+e8cVkb5geeGKKuavB6clJU4WmrGq0ZlkgEXTQ4+2Mst5v
	PBIXJ99oS/qoFHwz1XP15m8RL0svViuxFGckGmoxFxUnAgClWizfOwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/29/2012 02:16 AM, Mark Brown wrote:
> On Tue, Aug 28, 2012 at 08:25:30PM +0900, Joonyoung Shim wrote:
>> Consumer nodes can reference regulators using <name>-supply from dts
>> file with this patch.
>>
>> Signed-off-by: Joonyoung Shim <jy0922.shim@samsung.com>
>> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> This doesn't apply against current code, the changes already appear to
> be there...
>

OK. I checked it from regulator git for-next branch now.

Thanks.
