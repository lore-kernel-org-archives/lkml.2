Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758195Ab2K0HPX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 02:15:23 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:35353 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758065Ab2K0HPV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 02:15:21 -0500
X-AuditID: cbfee61b-b7f616d00000319b-5c-50b46887bfda
Message-id: <50B46880.30109@samsung.com>
Date: Tue, 27 Nov 2012 16:15:12 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.2) Gecko/20120216
 Thunderbird/10.0.2
MIME-version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] extcon: arizona: Only set GPIO if it has been requested
References: <1353929315-8874-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <50B3FAAB.9090406@samsung.com>
 <20121127063528.GU9411@opensource.wolfsonmicro.com>
In-reply-to: <20121127063528.GU9411@opensource.wolfsonmicro.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrIIsWRmVeSWpSXmKPExsVy+t8zHd32jC0BBvsmqltc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6M84d+sRe0sFdMXX2MtYHxDmsXIyeHhICJxJ652xghbDGJC/fW
	s4HYQgLLGCVuNqt0MXKA1dycm9TFyAUUXsQosf3zOUYIp4tJYtfB8ywgRbwCGhLrLlWC9LII
	qEp0TTrJDmKzCWhJ7H9xgw2kRFQgQuJXPwdImFdAUOLH5HtgnSJA43/frwSZyCywmFHiz54H
	YOcIC/hI7Hs7lx1i1WpGie/PXoDdxingIHH9VTOYzSygI7G/dRqULS+xec1bZogbBCS+TT7E
	AnG/rMSmA8wgcyQEutklmm9Ph/pdUuLgihssExjFZiG5aRaSsbOQjF3AyLyKUTS1ILmgOCk9
	10ivODG3uDQvXS85P3cTIyQepHcwrmqwOMQowMGoxMObuWhzgBBrYllxZe4hRgkOZiUR3sU6
	WwKEeFMSK6tSi/Lji0pzUosPMfoAXTuRWUo0OR8Yq3kl8YbGBsaGhpaGZqaWpgY4hJXEeZs9
	UgKEBNITS1KzU1MLUotgxjFxcEo1MHa1CVyX4P5wxIslNHb+L6t1lyx4tr+47nJQnHvlke16
	L03zHkmZneN+bSi0fp+EQtG08zsWPD30Q77pxiYV829Fnw1nqJuylfS6MU9dNXNrIovJMSve
	iTf32ka/PxjQditUf+LTwIVm86UXf3xS/7HGYKXgDY7muQuZ89f/+l/MrfQpV5qlrFiJpTgj
	0VCLuag4EQCMg0zMtAIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrIIsWRmVeSWpSXmKPExsVy+t9jAd32jC0BBr2/5C0u75rD5sDo8XmT
	XABjVAOjTUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7Q
	VCWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFBcD1GBmggYR1jxvlDv9gLWtgrpq4+xtrA
	eIe1i5GDQ0LAROLm3KQuRk4gU0ziwr31bF2MXBxCAosYJbZ/PscI4XQxSew6eJ4FpIFXQENi
	3aVKkAYWAVWJrkkn2UFsNgEtif0vbrCBlIgKREj86ucACfMKCEr8mHwPrFMEaNXv+5UgE5kF
	FjNK/NnzgBGkRljAR2Lf27nsEKtWM0p8f/aCDSTBKeAgcf1VM5jNLKAjsb91GpQtL7F5zVvm
	CYwCs5DsmIWkbBaSsgWMzKsYRVMLkguKk9JzjfSKE3OLS/PS9ZLzczcxguPtmfQOxlUNFocY
	BTgYlXh4MxdtDhBiTSwrrsw9xCjBwawkwrtYZ0uAEG9KYmVValF+fFFpTmrxIUYfYAhMZJYS
	Tc4HpoK8knhDYxMzI0sjM2MTc2NjHMJK4rzNHikBQgLpiSWp2ampBalFMOOYODilGhibew5n
	TT/l3Fz8aE7yr17nxqv/T52antcQmdF1/VVMUdLuqQeudMetN5keNNvtYPHM6Se/JezbbjH/
	4OuozA/zb8+oDLNU2atdtH7Ggi9m04ruK8TwHVZy4roiUz8zwb0g6WPa53sCcwyePb6QoLiJ
	f4mFQ6y434T+09JXfb/86d4sLGdexCunxFKckWioxVxUnAgAcQfqceQCAAA=
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/27/2012 03:35 PM, Mark Brown wrote:
> On Tue, Nov 27, 2012 at 08:26:35AM +0900, Chanwoo Choi wrote:
>> On 11/26/2012 08:28 PM, Mark Brown wrote:
> 
>>> +	if (arizona->pdata.micd_pol_gpio > 0)
>>> +		gpio_set_value_cansleep(arizona->pdata.micd_pol_gpio,
>>> +					info->micd_modes[mode].gpio);
> 
>> Why not use gpio_is_valid() function to test arizona->pdata.micd_pol_gpio ?
> 
> Zero is normally a valid GPIO (since it's an index into a big array
> after all) but this is unhelpful when checking to see if someone filled
> in platform data as it's also the default value for uninitialised member
> variables.  It's much more likely that someone didn't fill in a GPIO
> than that GPIO 0 got assigned to this.

OK, Applied it.

You can check it after some minutes.
- git://git.kernel.org/pub/scm/linux/kernel/git/chanwoo/extcon.git (for-next branch)

Thanks,
Chanwoo Choi
