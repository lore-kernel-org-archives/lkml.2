Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932658Ab1CIRF2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 12:05:28 -0500
Received: from mail-yi0-f46.google.com ([209.85.218.46]:53470 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754438Ab1CIRF1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 12:05:27 -0500
MIME-Version: 1.0
In-Reply-To: <4D7326B0.6050706@metafoo.de>
References: <1299385050-13674-1-git-send-email-bgat@billgatliff.com>
	<1299385050-13674-2-git-send-email-bgat@billgatliff.com>
	<4D7326B0.6050706@metafoo.de>
Date: Wed, 9 Mar 2011 11:05:27 -0600
Message-ID: <AANLkTinWwiyWkZ3vj6fpy7oe-PR6M+aVWoqh--+95Sgq@mail.gmail.com>
Subject: Re: [PWM v6 1/3] PWM: Implement a generic PWM framework
From: Bill Gatliff <bgat@billgatliff.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 6, 2011 at 12:16 AM, Lars-Peter Clausen <lars@metafoo.de> wrote:

>
>> +     if (IS_ERR(p->dev)) {
>> +             ret = PTR_ERR(p->dev);
>> +             goto err_device_create;
>> +     }
> I think it would be better to embedd the device struct directly into the
> pwm_device struct. You could also remove the data field of the pwm_device
> struct and use dev_{get,set}_drvdata for pwm_{get,set}_drvdata.

In theory I agree with you, but it would take away my ability to do
things like device_create_vargs() and thereby make my code a bit more
complicated and error prone.  Do you think the advantages outweigh the
disadvantages?


b.g.
-- 
Bill Gatliff
bgat@billgatliff.com
