Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753359Ab1CFMQo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Mar 2011 07:16:44 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:65146 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751553Ab1CFMQn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Mar 2011 07:16:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=Mvw4HuOG07LL2ClNHhvwnBGzZFTiF83+35/Ct/ERqfgNgxuNGl2LproJzT3Msuv7Zr
         yoMNtEUM6aU2BCoOfsvgWDTnRlWO8NHfDVjwVD4W4HNL4hEhvf5e4fiYB8P/gLIGEoVv
         eEVJugkfvK3G7rlv0hJ2WMM9JygRHXbOWhBl8=
MIME-Version: 1.0
In-Reply-To: <1299385050-13674-2-git-send-email-bgat@billgatliff.com>
References: <1299385050-13674-1-git-send-email-bgat@billgatliff.com>
	<1299385050-13674-2-git-send-email-bgat@billgatliff.com>
Date: Sun, 6 Mar 2011 13:16:43 +0100
X-Google-Sender-Auth: FvveDyaNWEXt_TunkaZw2P6Vf-k
Message-ID: <AANLkTinTRXPY4=FfAe2esu27WjZumiL7ng3cGHQ2aAe+@mail.gmail.com>
Subject: Re: [PWM v6 1/3] PWM: Implement a generic PWM framework
From: Linus Walleij <linus.walleij@linaro.org>
To: Bill Gatliff <bgat@billgatliff.com>
Cc: linux-kernel@vger.kernel.org, Arun MURTHY <arun.murthy@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/3/6 Bill Gatliff <bgat@billgatliff.com>:

> Updates the existing PWM-related functions to support multiple
> and/or hotplugged PWM devices, and adds a sysfs interface.
> Moves the code to drivers/pwm.

Cool!

> For now, this new code can exist alongside the current PWM
> implementations; the existing implementations will be migrated
> to this new framework as time permits.  Eventually, the current
> PWM implementation will be deprecated and then expunged.

Is it possible to get atleast one driver switched over to this
framework (i.e. moved over to drivers/pwm and the origin
deleted) as part of the patch series? Mainly so one knows
what to do to convert existing drivers.

Yours,
Linus Walleij
