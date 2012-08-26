Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752493Ab2HZXxy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Aug 2012 19:53:54 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:51400 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751087Ab2HZXxw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Aug 2012 19:53:52 -0400
X-AuditID: cbfee61a-b7fc66d0000043b7-ec-503ab70e2168
Message-id: <503AB70E.2000407@samsung.com>
Date: Mon, 27 Aug 2012 08:53:50 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.2) Gecko/20120216
 Thunderbird/10.0.2
MIME-version: 1.0
To: Randy Dunlap <rdunlap@xenotime.net>, Greg KH <gregkh@linuxfoundation.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH -next] extcon: extcon-arizona depends on INPUT
References: <20120824172820.ee0f412d2944b08789414207@canb.auug.org.au>
 <5037B41C.6040703@xenotime.net>
In-reply-to: <5037B41C.6040703@xenotime.net>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrNLMWRmVeSWpSXmKPExsVy+t9jAV2+7VYBBo2bDS0u75rDZnFwYRuj
	A5PH501yAYxRXDYpqTmZZalF+nYJXBmPF9xiKjjMUXG7bSVzA+Ne9i5GDg4JAROJ61OCuxg5
	gUwxiQv31rOB2EICixglNqyUg7BfMkq8Xy8BYvMKaEmcmjOdBcRmEVCVOL1kEzOIzQYU3//i
	BhvISFGBCIlf/RwQ5YISPybfAysXEfCVODLnJWMXIxcHs8BpRokbD5eBnSAs4CTxtE0cYlWG
	RN/TeawgNqeAjsTvnlfsIDYzkL2/dRobhC0vsXnNW+YJjAKzkKyYhaRsFpKyBYzMqxhFUwuS
	C4qT0nMN9YoTc4tL89L1kvNzNzGCg/CZ1A7GlQ0WhxgFOBiVeHgFSi0DhFgTy4orcw8xSnAw
	K4nwft8PFOJNSaysSi3Kjy8qzUktPsQozcGiJM7L32cYICSQnliSmp2aWpBaBJNl4uCUamBc
	KlSuPrOpfdlK8SKdF+f3yof3m9xWVxN6FSzp8lL89mPp21Htdblzpx+vcLMMD1JcraSxe/dp
	hnOq91v3PJv7VGHRIffXkdOtKz79Wdird/5TppMtG9Mm16MtOQ5p929oNre7CN/pei6yal7v
	77yZr94IZf3ZvUI7LTxUY90THodXMlePf3+kxFKckWioxVxUnAgAR0Fr2j4CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/25/2012 02:04 AM, Randy Dunlap wrote:

> From: Randy Dunlap <rdunlap@xenotime.net>
> 
> extcon-arizona uses input_*() functions so it should depend
> on INPUT.
> 
> ERROR: "input_event" [drivers/extcon/extcon-arizona.ko] undefined!
> ERROR: "input_free_device" [drivers/extcon/extcon-arizona.ko] undefined!
> ERROR: "input_register_device" [drivers/extcon/extcon-arizona.ko] undefined!
> ERROR: "input_set_capability" [drivers/extcon/extcon-arizona.ko] undefined!
> ERROR: "input_allocate_device" [drivers/extcon/extcon-arizona.ko] undefined!
> ERROR: "input_unregister_device" [drivers/extcon/extcon-arizona.ko] undefined!
> 
> Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
> Cc: MyungJoo Ham <myungjoo.ham@samsung.com>
> Cc: Chanwoo Choi <cw00.choi@samsung.com>
> Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---

Thanks much,

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>

I will apply this patch to
http://10.90.51.51/cgi-bin/gitweb.cgi?p=linux-samsung;a=shortlog;h=refs/heads/extcon-for-next
and you can check it after some hours.
