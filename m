Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755889Ab0EGJzY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 05:55:24 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:38770 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755533Ab0EGJzW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 05:55:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=jAs9L0vUk0/E1nwJcHQFYtItUqktLKLaZfQ5mizoIxzul5NfJjkmIjB3JoUrAyyY3X
         0Xes6jLxlLj7jyEXzEZDyDpAb9axmIh3jSAFiJA+3i3LTbA3tAlEd9V9rWLO73rk2/s4
         mNsZwv2yOjSLYaH2agteJG/oogWkzQa3jjbuU=
MIME-Version: 1.0
In-Reply-To: <4BE3E2DE.2030508@tuxonice.net>
References: <v2ubd0d95d71005061941j4f9272d1he7dc9bcf5daa6457@mail.gmail.com>
	 <CEE6BB42CAD6E947908279175AF8470A025A68CE5C@EXDCVYMBSTM006.EQ1STM.local>
	 <z2mbd0d95d71005070017w7aa97001m2b81be6dbc1021b9@mail.gmail.com>
	 <4BE3DF5A.9070601@tuxonice.net>
	 <g2gbd0d95d71005070250t510894a5ofcb384ebd1506c13@mail.gmail.com>
	 <4BE3E2DE.2030508@tuxonice.net>
Date: Fri, 7 May 2010 17:55:21 +0800
Message-ID: <g2lbd0d95d71005070255v52a0d7c1p855dc955c566ae85@mail.gmail.com>
Subject: Re: [PATCH] Check kmalloc return value before use the buffer
From: Steven Liu <lingjiujianke@gmail.com>
To: Nigel Cunningham <nigel@tuxonice.net>
Cc: Linus WALLEIJ <linus.walleij@stericsson.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, guy,

         Thanks for your help, :)


Best Regards


LiuQi

2010/5/7 Nigel Cunningham <nigel@tuxonice.net>:
> Hi.
>
> On 07/05/10 19:50, Steven Liu wrote:
>>
>> Check kmalloc return value before use the bigrxbuf_virtual ,when
>> bigrxbuf_virtual is NULL, kfree  bigtxbuf_virtual
>
> Ta :)
>
> Nigel
>
