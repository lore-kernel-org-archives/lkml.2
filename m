Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754140Ab1ALLIL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 06:08:11 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:44968 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752136Ab1ALLIH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 06:08:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=F6hd49W1yLhl41Igw/PB4mdaZz9MJZTliKJNUl2k7UMH6sgfnb3zIZKD7uocOTxBzv
         5+b7jL2jaNaB5LF4M9eBTXRM2s4bBvnnffpT5KCx50Y5gnpfNcfaiYfyyf9gb828s7So
         O24j+spv+b5sawS45ocjC72Q1ydqxZ5NcdRpA=
Message-ID: <4D2D8B12.2@gmail.com>
Date: Wed, 12 Jan 2011 12:05:54 +0100
From: Thomas Weber <thomas.weber.linux@googlemail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.13) Gecko/20101220 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: Manuel Stahl <manuel.stahl@iis.fraunhofer.de>
CC: linux-serial@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Thomas Weber <weber@corscience.de>, Johannes Reif <reif@corscience.de>,
        changgx <changgx@163.com>, miguelangel@nbee.es
Subject: Re: [PATCH resend 2] Add sc16is7x2 driver
References: <4D272DDA.6010007@iis.fraunhofer.de>
In-Reply-To: <4D272DDA.6010007@iis.fraunhofer.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 07.01.2011 16:14, schrieb Manuel Stahl:
> IRQ is now implemented with work queue (like max3100).
> The problem is, that the sc16is7x2 has a low active irq. But with active
> low threaded_irqs, shared irqs are not allowed.
> 
> Please try this one and report errors.
> 
> Regards,
> Manuel Stahl
> 
> PS: sorry that the patch is not inline, not sure how to configure
> thunderbird correctly

Hello Manuel,

There is a re-definition of PORT_SC16IS7X2 in serial_core.h
First time it is 20, second time it is 98.

Regards,
Thomas
