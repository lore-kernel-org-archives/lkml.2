Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932682Ab1ALAqA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 19:46:00 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:62749 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754210Ab1ALAp6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 19:45:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=cJy3eie4KI8MLtB1JZTAm9qZznti7T7+skLsN7ySgJFiHW+3NRnE+8/MSXfZOruT43
         D70Vh6XzaFVvOQGm/EaBQc1JH4gIR7hL7uqBRb8JMf2k09QQpLqlX13X/6yTDFBV2N2+
         47MeIfsIBpz0JB2xR1ZpfCcNjmHrrrCHVvT7U=
MIME-Version: 1.0
In-Reply-To: <E18F441196CA634DB8E1F1C56A50A874319FA7E37B@IRVEXCHCCR01.corp.ad.broadcom.com>
References: <4CFF58D2.4040006@kernel.org>
	<E18F441196CA634DB8E1F1C56A50A874319FA38C43@IRVEXCHCCR01.corp.ad.broadcom.com>
	<4CFFCD56.6050608@kernel.org>
	<E18F441196CA634DB8E1F1C56A50A874319FA7E36E@IRVEXCHCCR01.corp.ad.broadcom.com>
	<4CFFD3EB.10800@kernel.org>
	<E18F441196CA634DB8E1F1C56A50A874319FA7E36F@IRVEXCHCCR01.corp.ad.broadcom.com>
	<4CFFE29C.7080205@kernel.org>
	<E18F441196CA634DB8E1F1C56A50A874319FA38CD3@IRVEXCHCCR01.corp.ad.broadcom.com>
	<4D000C8B.5040904@kernel.org>
	<E18F441196CA634DB8E1F1C56A50A874319FD72B23@IRVEXCHCCR01.corp.ad.broadcom.com>
	<20110111182323.GG15933@htj.dyndns.org>
	<E18F441196CA634DB8E1F1C56A50A874319FA7E37B@IRVEXCHCCR01.corp.ad.broadcom.com>
Date: Tue, 11 Jan 2011 19:45:56 -0500
Message-ID: <AANLkTinpWS4yzAoHE5nTPtQ3OAU1SvM1mN2tMjsur8BW@mail.gmail.com>
Subject: Re: questions regarding possible violation of AHCI spec in AHCI driver
From: Harik <harik.attar@gmail.com>
To: Jian Peng <jipeng@broadcom.com>
Cc: Tejun Heo <tj@kernel.org>, Robert Hancock <hancockrwd@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jgarzik@pobox.com" <jgarzik@pobox.com>,
        ide <linux-ide@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +           (tmp & 0x0f) != 0x03) {
> +               printk(KERN_DEBUG "START bit was not set in %s\n", __func__);
> +               return;
> +       }

Are there defines for the mask and result that you could use instead of raw hex?
