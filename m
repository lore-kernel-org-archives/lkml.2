Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759274Ab2EDRor (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 13:44:47 -0400
Received: from mail-pz0-f45.google.com ([209.85.210.45]:32925 "EHLO
	mail-pz0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753125Ab2EDRop (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 13:44:45 -0400
X-Greylist: delayed 456 seconds by postgrey-1.27 at vger.kernel.org; Fri, 04 May 2012 13:44:45 EDT
MIME-Version: 1.0
In-Reply-To: <20120504045205.GA21624@richard>
References: <20120410090306.GA7056@richard>
	<20120422155202.GA13540@richard>
	<CAE9FiQXoUcUw5kOcBmsbBu_hJ+GbKk--qFt+WyUHbjJPwY+8Pw@mail.gmail.com>
	<CADLM8XPryGVVWVruB=sZ9zxPp-nEhz8xKeMhY3u8KBShk2suBQ@mail.gmail.com>
	<CAE9FiQXLxEEu68tJvph3LB53nqycK+YctwDKMEF824koXVM5AA@mail.gmail.com>
	<20120503065455.GA30042@richard>
	<CAE9FiQUVNA_jdRfsSR9Rv47aa6JX-HKET0z3SfK19wT=Fcd9Cg@mail.gmail.com>
	<20120504024721.GA6775@richard>
	<CAE9FiQUz2w815gU5vY5b0BPf+1pz_pafgzqVKizJC++z27RTaQ@mail.gmail.com>
	<20120504045205.GA21624@richard>
Date: Fri, 4 May 2012 10:37:08 -0700
X-Google-Sender-Auth: CYxOnh-PYvqFImme6n9ApjohMhs
Message-ID: <CAE9FiQWM4OTFp5NN+KOXxNREQxNWipDjWbbPPiHHJsb6yFmuiQ@mail.gmail.com>
Subject: Re: One problem in reassign pci bus number?
From: Yinghai Lu <yinghai@kernel.org>
To: Richard Yang <weiyang@linux.vnet.ibm.com>
Cc: Wei Yang <weiyang.kernel@gmail.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 3, 2012 at 9:52 PM, Richard Yang <weiyang@linux.vnet.ibm.com> wrote:
>
> BTW, even if this value is returned by __find_res_top_free_size(), or
> returned after this function is called, the purpose of the
> __find_res_top_free_size() is to get the biggest free space under the
> first parameter?

__find_res_top_free_size() is used to get size just under top,  and
then use it to calculate size above top that need to be extended.

at last will combine free size under top and allocated size above top
and return.

Yinghai
