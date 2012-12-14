Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753969Ab2LNHj4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 02:39:56 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:37951 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751088Ab2LNHjy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 02:39:54 -0500
X-AuditID: cbfee61a-b7fa66d0000004cf-76-50cad7c8b5e2
Message-id: <50CAD7D3.8030300@samsung.com>
Date: Fri, 14 Dec 2012 16:40:03 +0900
From: Joonyoung Shim <jy0922.shim@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-version: 1.0
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        kgene.kim@samsung.com, kyungmin.park@samsung.com
Subject: Re: [PATCH v2] pwm: samsung: add missing s3c->pwm_id
References: <1355468338-12611-1-git-send-email-jy0922.shim@samsung.com>
 <20121214073425.GC24094@avionic-0098.adnet.avionic-design.de>
In-reply-to: <20121214073425.GC24094@avionic-0098.adnet.avionic-design.de>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrOIsWRmVeSWpSXmKPExsVy+t8zHd0T108FGJzba2ZxedccNosZ5/cx
	OTB5fN4kF8AYxWWTkpqTWZZapG+XwJXR8fk5U8FS5oqJXXOZGxhvMHUxcnJICJhIXF/xGcoW
	k7hwbz0biC0ksIxRYtmtBJiag7+/s3QxcgHFpzNKnPoxnxnCeckosWPlfUaQKl4BLYn2p8fA
	JrEIqEq09+xlAbHZBPQk7mw7DhYXFfCTODv3HVS9oMSPyfeAajg4RARMJb7NEwEJMwuUS7T/
	3s0MYgsL2Ep8ufUZanE7o0THtxlgCU4BL4m2dZMYIRqsJVZO2gZly0tsXvOWGeIGAYlvkw+B
	zZcQkJXYdIAZ4pl2dom5fyshbEmJgytusExgFJuF5KJZSKbOQjJ1ASPzKkbR1ILkguKk9FxD
	veLE3OLSvHS95PzcTYyQ2JDawbiyweIQowAHoxIP70ehUwFCrIllxZW5hxglOJiVRHgljwCF
	eFMSK6tSi/Lji0pzUosPMfoAHTuRWUo0OR8Yt3kl8YbGBsaGhpaGZqaWpgY4hJXEeZs9UgKE
	BNITS1KzU1MLUotgxjFxcEo1MLrovQ+YXvNzlpXiLJ6J1xKLDd2UPkx/q+44/dUf/lfeYazS
	m77qT4kXFfvw76HnrNJjj2f2tjH0nb6banjDqOrB3bufZJbo7swXFmrf9px55Q6hExm3Zs+6
	s3iG8H9nG4Mkm1wWqXQ9N9ZFRWdsMv7X3pqwctc2K47zGYsmBSnOFJ/WeSDy/U8lluKMREMt
	5qLiRABTdUlNugIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrBIsWRmVeSWpSXmKPExsVy+t9jQd0T108FGExsNrK4vGsOm8WM8/uY
	HJg8Pm+SC2CMamC0yUhNTEktUkjNS85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ
	0HXLzAEaraRQlphTChQKSCwuVtK3wzQhNMRN1wKmMULXNyQIrsfIAA0krGPM6Pj8nKlgKXPF
	xK65zA2MN5i6GDk5JARMJA7+/s4CYYtJXLi3nq2LkYtDSGA6o8SpH/OZIZyXjBI7Vt5nBKni
	FdCSaH96DKybRUBVor1nL1g3m4CexJ1tx8HiogJ+EmfnvoOqF5T4MfkeUA0Hh4iAqcS3eSIg
	YWaBcon237uZQWxhAVuJL7c+s0DsameU6Pg2AyzBKeAl0bZuEiNEg7XEyknboGx5ic1r3jJP
	YBSYhWTFLCRls5CULWBkXsUomlqQXFCclJ5rqFecmFtcmpeul5yfu4kRHH3PpHYwrmywOMQo
	wMGoxMP7UehUgBBrYllxZe4hRgkOZiURXskjQCHelMTKqtSi/Pii0pzU4kOMPsAQmMgsJZqc
	D0wMeSXxhsYmZkaWRmbGJubGxjiElcR5mz1SAoQE0hNLUrNTUwtSi2DGMXFwSjUw5n24VVR8
	1036crhHAZtYRdC0y82zlEMcWo2izRjyqxYtZIwSrrwTsu7vlYwrPGd/pD6Ps5Bi53w6O+H/
	vM0i02uOyPF/yzPfvuTsftWP7QbXpPctOdoiraOy/XSO57el95yum97crvWBX+OaQ1vGxIu3
	vvW8fKZ77uyxowl7N72SSNu+1i9vjxJLcUaioRZzUXEiAA/1ixXrAgAA
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/14/2012 04:34 PM, Thierry Reding wrote:
> On Fri, Dec 14, 2012 at 03:58:58PM +0900, Joonyoung Shim wrote:
>> The s3c->pwm_id is used to calculate offset of related register.
>>
>> Signed-off-by: Joonyoung Shim <jy0922.shim@samsung.com>
> I've modified the subject a bit to make it clear the assignment of
> s3c->pwm_id was missing, not the s3c->pwm_id field altogether.
>
> Applied, thanks.

OK, thanks.
