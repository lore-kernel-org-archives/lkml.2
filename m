Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754985Ab2CUQzY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 12:55:24 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:44401 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753860Ab2CUQzT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 12:55:19 -0400
MIME-Version: 1.0
In-Reply-To: <1332262083-9375-1-git-send-email-walle@corscience.de>
References: <1332262083-9375-1-git-send-email-walle@corscience.de>
Date: Wed, 21 Mar 2012 18:55:18 +0200
Message-ID: <CANOLnOOJst6-3n5fOaKRST=MYEqVxsyX0TKX0qH=4HJ15DtywA@mail.gmail.com>
Subject: Re: [PATCH] mfd: Add TWL4030 PWM driver
From: Grazvydas Ignotas <notasas@gmail.com>
To: Bernhard Walle <walle@corscience.de>
Cc: sameo@linux.intel.com, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 20, 2012 at 6:48 PM, Bernhard Walle <walle@corscience.de> wrote:
> This PWM driver uses the PWM of the TWL4030. The driver for the TWL6030
> PWM has been used as mode, but the PWM registers are different.
>
> The driver can be used and has been tested in conjunction with
> pwm-backlight to control a backlight LED of a LCD touch screen.

Nice, could we also have LEDA and LEDB pwm control as pwm_id 2 and 3
in next version? No worries if you don't want it, I could try to take
a stab at that later.



-- 
Gražvydas
