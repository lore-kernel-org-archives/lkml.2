Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756452Ab1AaVe6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 16:34:58 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:63596 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756311Ab1AaVe5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 16:34:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=IMDTqIwiGr7Eat6W/LmZ7zQfXhGVVcJLXafEWZvjDtPiB2oYyRYtQTF7la9h++N19t
         GyEyXeQIeh0wBQ8jGXexyVRA4TgvHDXan+Xm6U8ThxyWYAauYC3ArW6vK906yQK51i+J
         qaxkQfOpoXi1LOsodajLFJLoyx0yYxImzqDwE=
MIME-Version: 1.0
In-Reply-To: <4D2D9834.5000309@iis.fraunhofer.de>
References: <4D272DDA.6010007@iis.fraunhofer.de>
	<4D2D8B12.2@gmail.com>
	<4D2D9834.5000309@iis.fraunhofer.de>
Date: Mon, 31 Jan 2011 22:34:56 +0100
Message-ID: <AANLkTimxM5WBn1=T8HJEiLnHmijKf-NahG9D1A0sH-yS@mail.gmail.com>
Subject: Re: [PATCH resend 2] Add sc16is7x2 driver
From: Thomas Weber <thomas.weber.linux@googlemail.com>
To: Manuel Stahl <manuel.stahl@iis.fraunhofer.de>
Cc: linux-serial@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Thomas Weber <weber@corscience.de>, Johannes Reif <reif@corscience.de>,
        changgx <changgx@163.com>, miguelangel@nbee.es
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/1/12 Manuel Stahl <manuel.stahl@iis.fraunhofer.de>:
> On 12.01.2011 12:05, Thomas Weber wrote:
>>
>> Am 07.01.2011 16:14, schrieb Manuel Stahl:
>>>
>>> IRQ is now implemented with work queue (like max3100).
>>> The problem is, that the sc16is7x2 has a low active irq. But with active
>>> low threaded_irqs, shared irqs are not allowed.
>>>
>>> Please try this one and report errors.
>>>
>>> Regards,
>>> Manuel Stahl
>>>
>>> PS: sorry that the patch is not inline, not sure how to configure
>>> thunderbird correctly
>>
>> Hello Manuel,
>>
>> There is a re-definition of PORT_SC16IS7X2 in serial_core.h
>> First time it is 20, second time it is 98.
>
> A sorry, forgot to delete the line with 20.
>
> Can someone already confirm that the this version works more reliably than
> the last one?
>
> Regards,
> Manuel Stahl
>

Hello Manuel,

Johannes reworked the patch and tested it. He is at school in the
moment, but he told me that it works now. Can you send a fixed patch?

Thomas
