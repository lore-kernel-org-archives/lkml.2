Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756435Ab0EGJwf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 05:52:35 -0400
Received: from crca.org.au ([74.207.252.120]:39100 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756414Ab0EGJwe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 05:52:34 -0400
X-Bogosity: Ham, spamicity=0.000983
Message-ID: <4BE3E2DE.2030508@tuxonice.net>
Date: Fri, 07 May 2010 19:52:30 +1000
From: Nigel Cunningham <nigel@tuxonice.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100423 Thunderbird/3.0.4
MIME-Version: 1.0
To: Steven Liu <lingjiujianke@gmail.com>
CC: Linus WALLEIJ <linus.walleij@stericsson.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Check kmalloc return value before use the buffer
References: <v2ubd0d95d71005061941j4f9272d1he7dc9bcf5daa6457@mail.gmail.com>	 <CEE6BB42CAD6E947908279175AF8470A025A68CE5C@EXDCVYMBSTM006.EQ1STM.local>	 <z2mbd0d95d71005070017w7aa97001m2b81be6dbc1021b9@mail.gmail.com>	 <4BE3DF5A.9070601@tuxonice.net> <g2gbd0d95d71005070250t510894a5ofcb384ebd1506c13@mail.gmail.com>
In-Reply-To: <g2gbd0d95d71005070250t510894a5ofcb384ebd1506c13@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On 07/05/10 19:50, Steven Liu wrote:
> Check kmalloc return value before use the bigrxbuf_virtual ,when
> bigrxbuf_virtual is NULL, kfree  bigtxbuf_virtual

Ta :)

Nigel
