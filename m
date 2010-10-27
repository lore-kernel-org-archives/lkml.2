Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754086Ab0J0Rwh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 13:52:37 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:58458 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753780Ab0J0Rwg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 13:52:36 -0400
MIME-Version: 1.0
In-Reply-To: <4CC85771.2080307@redhat.com>
References: <4CC8380D.3040802@redhat.com>
	<4CC84597.4000204@gmail.com>
	<4CC84846.6020304@redhat.com>
	<AANLkTim=RfR3Dq0w+ACYjhGTHCSgapdf35wGW8QoZ38n@mail.gmail.com>
	<4CC85771.2080307@redhat.com>
Date: Wed, 27 Oct 2010 13:52:34 -0400
Message-ID: <AANLkTimS2FwZfruag0rBnbpEQoqTEUSXf14XGpZYQdAO@mail.gmail.com>
Subject: Re: [GIT PULL for 2.6.37-rc1] V4L/DVB updates
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Jiri Slaby <jirislaby@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Michael Krufky <mkrufky@kernellabs.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 27, 2010 at 12:46 PM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
> The original code is broken, as it doesn't properly honour a max size of 8.
> Even if we do some optimization at cx231xx, we still need to fix the tda18271
> code, as it is trying to use more than 8 bytes on some writes.
>
> Also, as you noticed, the way cx231xx sends large firmwares to xc5000 is a hack:
> it requires to identify that the I2C device is a xc5000 and do an special
> treatment for it.

Yes, it does currently only get run if it's an xc5000, but I believe
that code path could be used for *all* devices.  There is no reason
that it needs to be a hack as that behavior should be the default case
(presumably Conexant just didn't want to retest against other
devices).

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
