Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755472Ab1BWAKo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 19:10:44 -0500
Received: from fifo99.com ([67.223.236.141]:55722 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755194Ab1BWAKm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 19:10:42 -0500
Subject: Re: [PATCH] msm: add single-wire serial bus interface (SSBI) driver
From: Daniel Walker <dwalker@fifo99.com>
To: Dima Zavin <dima@android.com>
Cc: Bryan Huntsman <bryanh@codeaurora.org>,
        Kenneth Heitke <kheitke@codeaurora.org>, Pavel Machek <pavel@ucw.cz>,
        davidb@codeaurora.org, tsoni@codeaurora.org,
        linux-arm-msm@vger.kernel.org,
        ARM PORT <linux-arm-kernel@lists.infradead.org>,
        open list <linux-kernel@vger.kernel.org>
In-Reply-To: <AANLkTi=0Pxg09x8DdVDVy9Ur7r1dgB+4LM3q0hM4_8Rg@mail.gmail.com>
References: <1297989299-27320-1-git-send-email-kheitke@codeaurora.org>
	 <1297989432.9680.50.camel@c-dwalke-linux.qualcomm.com>
	 <4D5DC289.1090004@codeaurora.org>
	 <1298054771.17758.1.camel@c-dwalke-linux.qualcomm.com>
	 <AANLkTi=0Pxg09x8DdVDVy9Ur7r1dgB+4LM3q0hM4_8Rg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 22 Feb 2011 16:10:39 -0800
Message-ID: <1298419839.17118.5.camel@m0nster>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-02-22 at 12:47 -0800, Dima Zavin wrote:

> What is the problem leaving it under arch/arm/mach-msm?

Because it's a driver.

Daniel

