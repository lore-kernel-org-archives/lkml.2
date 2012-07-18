Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754899Ab2GRQEm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 12:04:42 -0400
Received: from oproxy5-pub.bluehost.com ([67.222.38.55]:42284 "HELO
	oproxy5-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753271Ab2GRQEi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 12:04:38 -0400
Message-ID: <5006DE5F.8010700@xenotime.net>
Date: Wed, 18 Jul 2012 09:03:43 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Shashidhar Hiremath <shashidharh@vayavyalabs.com>
CC: lkml <linux-kernel@vger.kernel.org>
Subject: Re: A question on printascii
References: <CANYdXnrf-f2e=3YKpwweSmvrYdmy7z_yOEyZ11k=La=8b3W6Pw@mail.gmail.com>
In-Reply-To: <CANYdXnrf-f2e=3YKpwweSmvrYdmy7z_yOEyZ11k=La=8b3W6Pw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/18/2012 06:03 AM, Shashidhar Hiremath wrote:

> HI,
>   I want to use printascii to debug my serial driver. How do I enable
> it and use the feature.
>   Currently I have enabled in menuconfig and done an extern on the
> printascii api, this doesn't seem to work, So any hints for debugging
> serial drivers ?
> 


Enabled what/where in menuconfig?

It looks like only a few CPU architecures or platforms
implement "printascii".  What architecture/platform are you trying
to use it on?

-- 
~Randy
