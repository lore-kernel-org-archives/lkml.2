Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753708Ab2KTW5Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 17:57:16 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:29005 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752883Ab2KTW5O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 17:57:14 -0500
X-AuditID: cbfee61a-b7fa66d0000004cf-d8-50ac0ac8e4e8
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Olof Johansson'" <olof@lixom.net>,
        "'Doug Anderson'" <dianders@chromium.org>
Cc: linux-samsung-soc@vger.kernel.org, "'Olof Johansson'" <olofj@chromium.org>,
        "'Thomas Abraham'" <thomas.abraham@linaro.org>,
        "'Russell King'" <linux@arm.linux.org.uk>,
        "'Shawn Guo'" <shawn.guo@linaro.org>,
        "'Rob Herring'" <rob.herring@calxeda.com>,
        "'Josh Cartwright'" <josh.cartwright@ni.com>,
        "'Rahul Sharma'" <rahul.sharma@samsung.com>,
        "'Arun Kumar K'" <arun.kk@samsung.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <1353432158-22999-1-git-send-email-dianders@chromium.org>
 <1353432158-22999-2-git-send-email-dianders@chromium.org>
 <CAOesGMiGZHAw0zOZFZcYJ9YngbcMsTJrzhG+DQ5sP9Sq+CyzDQ@mail.gmail.com>
In-reply-to: <CAOesGMiGZHAw0zOZFZcYJ9YngbcMsTJrzhG+DQ5sP9Sq+CyzDQ@mail.gmail.com>
Subject: RE: [PATCH 2/2] ARM: dts: snow: Add board dts file for Snow board (ARM
 Chromebook)
Date: Wed, 21 Nov 2012 07:57:11 +0900
Message-id: <0d5301cdc772$605a4420$210ecc60$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac3HTwExOaL9MfUpTZykk07DvrvdLwAIpD/A
Content-language: ko
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNIsWRmVeSWpSXmKPExsVy+t8zQ90TXGsCDC7O47O4vGsOm8WM8/uY
	HJg8Pm+SC2CM4rJJSc3JLEst0rdL4Mpof7OZseART8Xe9b8ZGxibuboYOTgkBEwk5s337GLk
	BDLFJC7cW8/WxcjFISSwjFHi4ac97DA1h1vFIOKLGCWe3LsHVfSXUeLfud8sIN1sAhoSh98/
	YwexRQT8JDZ0bmABKWIW2M8sMWHCc6iOE4wSn57tZAQZyykQLPF8hh9Ig7BArMSHy3+ZQWwW
	AVWJG9N/soHYvAK2Eg9/vYeyBSV+TL4HtoxZQEti/c7jTBC2vMTmNW+ZIS5Vl3j0VxfiBiOJ
	fT8nsEOUiEjse/GOEWK8gMS3yYdYIMplJTYdYAa5TEJgFbvEvGs3WCEhISlxcMUNlgmMErOQ
	bJ6FZPMsJJtnIVmxgJFlFaNoakFyQXFSeq6hXnFibnFpXrpecn7uJkZIjEntYFzZYHGIUYCD
	UYmHd+Pa1QFCrIllxZW5hxglOJiVRHj/bwQK8aYkVlalFuXHF5XmpBYfYvQBunwis5Rocj4w
	/vNK4g2NjU3MTExNzC1NzU1xCCuJ8zZ7pAQICaQnlqRmp6YWpBbBjGPi4JRqYKy8eCpVbqX+
	/IsbeMtifM12NZy4qKhhdk8i8GC28HtmH3PbfwtVvZRma7ZMfuBiv/Vj15a5ukd/1P35brfG
	d/U2/skdQVodPmZT3v2YMcnn/Yc7xhPDuPYvPL+7OXP2lxfMNw37J6Sl+87be/fein/qE+Ly
	Z97hfrHzwv2TydabP4X6rZ2VkV6ixFKckWioxVxUnAgAP1vFtd4CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrNIsWRmVeSWpSXmKPExsVy+t9jAd0TXGsCDKZPYre4vGsOm8WM8/uY
	HJg8Pm+SC2CMamC0yUhNTEktUkjNS85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ
	0HXLzAEaraRQlphTChQKSCwuVtK3wzQhNMRN1wKmMULXNyQIrsfIAA0krGPMaH+zmbHgEU/F
	3vW/GRsYm7m6GDk4JARMJA63inUxcgKZYhIX7q1n62Lk4hASWMQo8eTePSjnL6PEv3O/WUCq
	2AQ0JA6/f8YOYosI+Els6NzAAlLELLCfWWLChOdQHScYJT4928kIsoJTIFji+Qw/kAZhgViJ
	D5f/MoPYLAKqEjem/2QDsXkFbCUe/noPZQtK/Jh8D2wZs4CWxPqdx5kgbHmJzWveMkNcrS7x
	6K8uxA1GEvt+TmCHKBGR2PfiHeMERqFZSCbNQjJpFpJJs5C0LGBkWcUomlqQXFCclJ5rqFec
	mFtcmpeul5yfu4kRHMPPpHYwrmywOMQowMGoxMO7ce3qACHWxLLiytxDjBIczEoivP83AoV4
	UxIrq1KL8uOLSnNSiw8x+gA9OpFZSjQ5H5he8kriDY1NzIwsjcwsjEzMzXEIK4nzNnukBAgJ
	pCeWpGanphakFsGMY+LglGpgvJDhmPMqQjFn607VM7MeS2690S79cbtMQuhKPdbHT360Tqh0
	OmGw8dDZjXLnePMmcrPpW4qUrz+fyqlYmRv4ZeGfD045Rysv3/Itc7eLXNItd3au5/8fwj+W
	TDC6nDxjGydTxOQL6dmFbN3aLEsSgjV22FXfqAted7qo6xPbqWlrVm54d6fPSomlOCPRUIu5
	qDgRAO8Pm6EOAwAA
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Olof Johansson wrote:
> 
> On Tue, Nov 20, 2012 at 9:22 AM, Doug Anderson <dianders@chromium.org>
> wrote:
> > This dts file is based on the Snow dts file in the Chromium OS kernel
> > tree with the following changes:
> > * Some details have been updated to match the exynos5250-smdk5250.dts
> >   file from linux-next (as of
> >   c11068538994430547722dc9fb515a0ceefd5cb9).
> > * This file doesn't include references to hardware whose upstream
> >   support isn't quite there yet.  That includes most i2c devices.
> >   Note that most i2c busses have been included with no devices.
> >
> > The Snow dts file is mostly just an include of the "cros5250" dts file
> > which describes a class of similar boards.  Support for other boards
> > has not yet been send upstream.
> >
> > With this file and a change to use UART3 for serial output I can:
> > * Boot to a command line using either SD or EMMC as a root filesystem
> > * See the power button and lid switch using evtest.
> >
> > Signed-off-by: Doug Anderson <dianders@chromium.org>
> 
> Acked-by: Olof Johansson <olof@lixom.net>
> 
> Kukjin, since your pull requests came in today, can you ack this and
> I'll just apply it on top of your branches?
> 
Hi Olof, yeah, I sent pull-request but there are some patches for dt and
exynos5440 stuff in my tree not sent yet. If you're ok, let me take this
with your ack.

Note, I will try to send out remained Samsung stuff before release -rc7 ;-)

Thanks.

Best regards,
Kgene.
--
Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
SW Solution Development Team, Samsung Electronics Co., Ltd.

