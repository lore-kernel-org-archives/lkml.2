Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759772Ab2C2SOv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 14:14:51 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38706 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759221Ab2C2SOr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 14:14:47 -0400
Message-ID: <4F74A68E.9060202@zytor.com>
Date: Thu, 29 Mar 2012 11:14:38 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: Kees Cook <keescook@google.com>
CC: "Ted Ts'o" <tytso@mit.edu>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Correct way to include siginfo.h?
References: <CAGXu5jK3ezCN2=hy=AARh=T9L8YzCTKAXH6dbAH7FGX3P8VkoQ@mail.gmail.com> <20120327172133.GB10142@thunk.org> <CAGXu5jJx85b2ysgx2aXWUUf4dJMc34Cukp3S1VKiC_Pc5U2+Pw@mail.gmail.com> <20120327173744.GD10142@thunk.org> <CAGXu5j+itrR6cCWpXZAA0ZEP2KhdHdhcYA-R6pc=B97a_rHbaQ@mail.gmail.com> <4F74A2C9.1000009@zytor.com> <CAGXu5jKaHygqzfbtahSBCM=EQmqkS8br5ndnLp0QCRFaka11SA@mail.gmail.com>
In-Reply-To: <CAGXu5jKaHygqzfbtahSBCM=EQmqkS8br5ndnLp0QCRFaka11SA@mail.gmail.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/29/2012 11:13 AM, Kees Cook wrote:
> 
> We'll have to poke the glibc folks. In the meantime, Will Drewry found
> a stable way to handle this. Just make the first set of includes and
> defines be:
> 

Well, "recent events" hopefully make that a bit easier.

	-hpa

