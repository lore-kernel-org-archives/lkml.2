Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757510Ab2CBOWZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 09:22:25 -0500
Received: from mail1.windriver.com ([147.11.146.13]:58612 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757359Ab2CBOWX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 09:22:23 -0500
Message-ID: <4F50D78A.1020209@windriver.com>
Date: Fri, 2 Mar 2012 09:22:02 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.27) Gecko/20120216 Thunderbird/3.1.19
MIME-Version: 1.0
To: Fabio Estevam <festevam@gmail.com>
CC: <linux-kernel@vger.kernel.org>, <akpm@linux-foundation.org>,
        <linux@arm.linux.org.uk>, <sam@ravnborg.org>,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: Re: [PATCH v2] compiler.h: Include <linux/bug.h> to avoid build breakage
 with ARRAY_SIZE()
References: <1330436499-17190-1-git-send-email-fabio.estevam@freescale.com>	<1330650922-24143-1-git-send-email-festevam@gmail.com>	<CAP=VYLpd5EFmD+8Yo_jm-9N7O5zkLTsTwGjgmxG4u_G6t=4fag@mail.gmail.com> <CAOMZO5DYNdp=1h9WJ7QRBJSAe-pJEerVZmA0tro+7brhZi6PxQ@mail.gmail.com>
In-Reply-To: <CAOMZO5DYNdp=1h9WJ7QRBJSAe-pJEerVZmA0tro+7brhZi6PxQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [128.224.146.65]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12-03-01 10:13 PM, Fabio Estevam wrote:
> On Thu, Mar 1, 2012 at 11:49 PM, Paul Gortmaker
> <paul.gortmaker@windriver.com> wrote:
> 
>> Thanks, but no.
>>
>> You missed the whole point of my previous comments -- that being
>> that we don't want to just jam headers into always-used headers.
> 
> Yes, it is not clear for me how to fix this build error. I got
> different feedbacks from you, Russell and Sam.

Understood, there was some discussion there.  Anyways it is already
dealt with in yesterday's linux-next tree, so you won't have the
build failure anymore.

Thanks,
Paul.

> 
>> The compiler.h is going to be an "always used" header.  So if we
>> can avoid stuffing it full of extra crap, we need to really try.
> 
> So let me ask you: how do you want me to fix the build error I am seeing?
