Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752747Ab1CGQ2b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 11:28:31 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:54476 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751184Ab1CGQ2a convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 11:28:30 -0500
MIME-Version: 1.0
In-Reply-To: <4D732B25.2010708@metafoo.de>
References: <1299385050-13674-1-git-send-email-bgat@billgatliff.com>
	<1299385050-13674-2-git-send-email-bgat@billgatliff.com>
	<4D7326B0.6050706@metafoo.de>
	<4D732B25.2010708@metafoo.de>
Date: Mon, 7 Mar 2011 10:28:30 -0600
Message-ID: <AANLkTinJM4YNL-H-QKtsqTWwRksK=__KUCgY5wDP-c+E@mail.gmail.com>
Subject: Re: [PWM v6 1/3] PWM: Implement a generic PWM framework
From: Bill Gatliff <bgat@billgatliff.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lars:

On Sun, Mar 6, 2011 at 12:35 AM, Lars-Peter Clausen <lars@metafoo.de> wrote:
> On 03/06/2011 07:16 AM, Lars-Peter Clausen wrote:
>> On 03/06/2011 05:17 AM, Bill Gatliff wrote:
>>> +
>>> +
>>> +pwm_set_handler() -- Defines an end-of-period callback.  The indicated
>>> +function will be invoked in a worker thread at the end of each PWM
>>> +period, and can subsequently invoke pwm_config(), etc.  Must be used
>>> +with extreme care for high-speed PWM outputs.  Set the handler
>>> +function to NULL to un-set the handler.
>>> +
>
> This looks like a poor man's IRQ handler implementation. In my opinion something
> like pwm_to_irq would be better suited interface.

Not sure what you mean here.  Can you elaborate?


b.g.
-- 
Bill Gatliff
bgat@billgatliff.com
