Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756896Ab2CBDNm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 22:13:42 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:48171 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756362Ab2CBDNl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 22:13:41 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of festevam@gmail.com designates 10.14.131.13 as permitted sender) smtp.mail=festevam@gmail.com; dkim=pass header.i=festevam@gmail.com
MIME-Version: 1.0
In-Reply-To: <CAP=VYLpd5EFmD+8Yo_jm-9N7O5zkLTsTwGjgmxG4u_G6t=4fag@mail.gmail.com>
References: <1330436499-17190-1-git-send-email-fabio.estevam@freescale.com>
	<1330650922-24143-1-git-send-email-festevam@gmail.com>
	<CAP=VYLpd5EFmD+8Yo_jm-9N7O5zkLTsTwGjgmxG4u_G6t=4fag@mail.gmail.com>
Date: Fri, 2 Mar 2012 00:13:40 -0300
Message-ID: <CAOMZO5DYNdp=1h9WJ7QRBJSAe-pJEerVZmA0tro+7brhZi6PxQ@mail.gmail.com>
Subject: Re: [PATCH v2] compiler.h: Include <linux/bug.h> to avoid build
 breakage with ARRAY_SIZE()
From: Fabio Estevam <festevam@gmail.com>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        linux@arm.linux.org.uk, sam@ravnborg.org,
        Fabio Estevam <fabio.estevam@freescale.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 1, 2012 at 11:49 PM, Paul Gortmaker
<paul.gortmaker@windriver.com> wrote:

> Thanks, but no.
>
> You missed the whole point of my previous comments -- that being
> that we don't want to just jam headers into always-used headers.

Yes, it is not clear for me how to fix this build error. I got
different feedbacks from you, Russell and Sam.

> The compiler.h is going to be an "always used" header.  So if we
> can avoid stuffing it full of extra crap, we need to really try.

So let me ask you: how do you want me to fix the build error I am seeing?
