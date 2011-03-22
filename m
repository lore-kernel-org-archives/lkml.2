Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753564Ab1CVSuj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 14:50:39 -0400
Received: from www.linutronix.de ([62.245.132.108]:56103 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751778Ab1CVSui (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 14:50:38 -0400
Date: Tue, 22 Mar 2011 19:50:29 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Abhijeet Dharmapurikar <adharmap@codeaurora.org>
cc: davidb@codeaurora.org, dwalker@fifo99.com,
        Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        linux-arm-msm-owner@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.intradead.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Linus Walleij <linux.walleij@linaro.org>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PM8921 MFD V4 2/2] mfd: pm8xxx: Add irq support
In-Reply-To: <1300471255-30285-1-git-send-email-adharmap@codeaurora.org>
Message-ID: <alpine.LFD.2.00.1103221949220.31464@localhost6.localdomain6>
References: <1300471255-30285-1-git-send-email-adharmap@codeaurora.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Mar 2011, adharmap@codeaurora.org wrote:

> Add support for the irq controller in Qualcomm 8xxx pmic. The 8xxx
> interrupt controller provides control for gpio and mpp configured as
> interrupts in addition to other subdevice interrupts. The interrupt
> controller also provides a way to read the real time status of an
> interrupt. This real time status is the only way one can get the
> input values of gpio and mpp lines.
> 
> Signed-off-by: Abhijeet Dharmapurikar <adharmap@codeaurora.org>

Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
