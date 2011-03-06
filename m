Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751357Ab1CFGeJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Mar 2011 01:34:09 -0500
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:32898 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751029Ab1CFGeE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Mar 2011 01:34:04 -0500
Message-ID: <4D732B25.2010708@metafoo.de>
Date: Sun, 06 Mar 2011 07:35:17 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101226 Icedove/3.0.11
MIME-Version: 1.0
To: Bill Gatliff <bgat@billgatliff.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PWM v6 1/3] PWM: Implement a generic PWM framework
References: <1299385050-13674-1-git-send-email-bgat@billgatliff.com> <1299385050-13674-2-git-send-email-bgat@billgatliff.com> <4D7326B0.6050706@metafoo.de>
In-Reply-To: <4D7326B0.6050706@metafoo.de>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/06/2011 07:16 AM, Lars-Peter Clausen wrote:
> On 03/06/2011 05:17 AM, Bill Gatliff wrote:
>> +
>> +
>> +pwm_set_handler() -- Defines an end-of-period callback.  The indicated
>> +function will be invoked in a worker thread at the end of each PWM
>> +period, and can subsequently invoke pwm_config(), etc.  Must be used
>> +with extreme care for high-speed PWM outputs.  Set the handler
>> +function to NULL to un-set the handler.
>> +

This looks like a poor man's IRQ handler implementation. In my opinion something
like pwm_to_irq would be better suited interface.

- Lars
