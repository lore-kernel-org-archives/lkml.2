Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751663Ab0GNFUP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 01:20:15 -0400
Received: from smtprelay04.ispgateway.de ([80.67.31.27]:34945 "EHLO
	smtprelay04.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750983Ab0GNFUO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 01:20:14 -0400
Message-ID: <20100714072012.21363okof2qiqomc@webmail.df.eu>
Date: Wed, 14 Jul 2010 07:20:12 +0200
From: peter@piie.net
To: Borislav Petkov <bp@alien8.de>
Cc: Branislav Gajdos <brianzee@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: acerhdf.c - unsupported notebook
References: <AANLkTin0mv0Z5vozJHkfVYCJTWMvj9JZnP_FcQ6vZBRV@mail.gmail.com>
 <20100713124840.GA16427@a1.tnic>
 <AANLkTimBhWKo0zxW6fX5RgLLAQVIdItS5RKpvxqkDlis@mail.gmail.com>
 <20100713151329.GA17516@a1.tnic>
 <cone.1279041124.439539.3902.1000@deskpiie>
 <AANLkTimiZcGY04wDK0yLtGrDknP-amyUaWybqsD5DHqC@mail.gmail.com>
 <20100713204235.GA32085@liondog.tnic>
In-Reply-To: <20100713204235.GA32085@liondog.tnic>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=ISO-8859-1;
 DelSp="Yes";
 format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
User-Agent: Dynamic Internet Messaging Program (DIMP) H3 (1.1.2)
X-Originating-IP: 80.82.223.8
X-Df-Sender: 650477
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Boris, Hi Branislav,

Quoting Borislav Petkov <bp@alien8.de>:

> From: Branislav Gajdos <brianzee@gmail.com>
> Date: Tue, Jul 13, 2010 at 10:30:14PM +0200
>
>> So that means you would keep there the definitions for Core 2 based
>> models as well, right?

The 1810's are already supported by acerhdf and some people use it for  
fan control, so we should keep it, but we should enhance the bios_tbl  
by "default_fanon" and "default_fanoff". What do you think Boris?

> You still didn't answer my question whether your fan is noisy? IOW, does
> it make sense for you to use this driver at all?

Haven't got any email from a 3810 user to add support for this model,  
so for me it seems like the fan isn't noisy at all. - Usually as soon  
as a new model with a noisy fan comes out the people are spaming my  
inbox and crying ;)

kind regards,
--peter;


