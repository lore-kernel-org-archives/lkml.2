Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759623Ab2GLXqw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 19:46:52 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:36965 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759581Ab2GLXqk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 19:46:40 -0400
X-AuditID: cbfee61a-b7f616d000004b7e-1b-4fff61df1cee
Message-id: <4FFF61DF.4030309@samsung.com>
Date: Fri, 13 Jul 2012 08:46:39 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.2) Gecko/20120216
 Thunderbird/10.0.2
MIME-version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: gregkh@linuxfoundation.org, sameo@linux.intel.com,
        myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] extcon: Remove CONFIG_EXTCON_MODULE config to fix build
 break
References: <1342067547-6276-1-git-send-email-cw00.choi@samsung.com>
 <20120712161621.GB7256@opensource.wolfsonmicro.com>
In-reply-to: <20120712161621.GB7256@opensource.wolfsonmicro.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrOLMWRmVeSWpSXmKPExsVy+t9jAd37if/9Dd6ek7W4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZ3Y/YCu6wVdxr/MHUwLiGtYuRk0NCwETi+Kp2dghbTOLCvfVs
	XYxcHEICixglZl9uAksICXQxSfx9kwZi8wpoSTQu+gPWzCKgKrFu+i4mEJsNKL7/xQ2gZg4O
	UYEIiV/9HBDlghI/Jt9jAQmLAO36fb8SZDyzQA+jRPuDb2CtwgIhEs8/z2CGWFUlsavtBNh4
	TgEHiYe/d4LZzAI6Evtbp7FB2PISm9e8ZZ7AKDALyYpZSMpmISlbwMi8ilE0tSC5oDgpPddQ
	rzgxt7g0L10vOT93EyM4+J5J7WBc2WBxiFGAg1GJh3dB9H9/IdbEsuLK3EOMEhzMSiK86+yB
	QrwpiZVVqUX58UWlOanFhxilOViUxHmNvb/6CwmkJ5akZqemFqQWwWSZODilGhgP776Sc/Gt
	z7Ji3oPJZxbaBfXxMJ1X1bKZvexLUM/evSmyi8X2vozSqFH94vZgzu4K1zkayskLuqdO4Uhr
	yMm9wd5jrPJVc/6Wm6qfL5XkP2+NmfrRcdGMfLYmF67Ql635jTOEk+f4tFplFX4P3cVqOdnD
	JGHXvqiHE9+Eme9YLWvB8Nxvd50SS3FGoqEWc1FxIgB2x8CxOgIAAA==
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/13/2012 01:16 AM, Mark Brown wrote:

> On Thu, Jul 12, 2012 at 01:32:27PM +0900, Chanwoo Choi wrote:
>> This patch modify 'Kconfig' of EXTCON Subsystem to support either
>> active or inactive of EXTCON Subsystem. The various subsystem refer
>> to EXTCON subsystem for controlling external connector, so core class
>> of EXTCON should be included in kernel image. If EXTCON subsystem is
>> builded with MODULE, other subsystem have build break because of
>> linking the core class of EXTCON.
> 
> By this logic very little in the kernel should be a module.  We usually
> only force things to be built in if there's a technical need for it like
> init ordering constraints.  Generally this is just a case of making sure
> the Kconfig stuff is set up with appropriate dependencies.


As you said, I will fix it.

Thank you,
Chanwoo Choi
