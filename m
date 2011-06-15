Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755824Ab1FOPdY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 11:33:24 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:49310 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755800Ab1FOPdW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 11:33:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=fdVtsPIHngBzSjVcesQDNxI2sQ0qusU43na9rY0CjguJT1wh2jD3xvmT5bro6YKJdN
         vtaIbBNNJJ7jbvJbTqcZpBmYId2GFEGUmXFnd0PKTSovrjhZt4f0Ma+hm/ep7ZWXBCTQ
         wCBEwjyDYSmnGbIFqhxUUWVJEEhCQn6MBRZV8=
MIME-Version: 1.0
In-Reply-To: <1301630392-20793-1-git-send-email-bgat@billgatliff.com>
References: <1301630392-20793-1-git-send-email-bgat@billgatliff.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Wed, 15 Jun 2011 11:33:00 -0400
Message-ID: <BANLkTikD66EheEQem82yPocCs6Bzqoa4kg@mail.gmail.com>
Subject: Re: [PWM v9 0/3] Implement a generic PWM framework
To: Bill Gatliff <bgat@billgatliff.com>
Cc: linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 31, 2011 at 23:59, Bill Gatliff wrote:
> This patch series contains the ninth attempt at implementation of a
> generic PWM device interface framework.  Think gpiolib, but for
> devices and pseudo-devices that generate pulse-wave-modulated outputs.

i was made aware of the existing code in linux/pwm.h.  seems that this
framework should absorb that since there are already drivers built on
top of it (i see a backlight, led, and input driver), and we dont want
two frameworks doing exactly the same thing.
-mike
