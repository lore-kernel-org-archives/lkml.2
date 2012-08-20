Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756283Ab2HTNxG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 09:53:06 -0400
Received: from mail.active-venture.com ([67.228.131.205]:53008 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751499Ab2HTNxB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 09:53:01 -0400
X-Originating-IP: 108.223.40.66
Date: Mon, 20 Aug 2012 06:53:03 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Simon Budig <simon.budig@kernelconcepts.de>,
        Henrik Rydberg <rydberg@euromail.se>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: Re: [PATCH] Input: Let the FT5x06 driver build without debugfs
Message-ID: <20120820135303.GA9278@roeck-us.net>
References: <87k3wy1ii3.fsf@xmission.com>
 <502DFC1D.20903@kernelconcepts.de>
 <87boi91g01.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87boi91g01.fsf@xmission.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 17, 2012 at 12:21:34PM -0700, Eric W. Biederman wrote:
> Simon Budig <simon.budig@kernelconcepts.de> writes:
> 
> > On 08/17/2012 02:15 AM, Eric W. Biederman wrote:
> >> When testing to make certain my user namespace code works in
> >> various configurations I tripped over the tf5x06.c not building
> >> with debugfs disabled.
> >
> > Sorry for that.
> >
> > There already is a patch for this issue which I slightly prefer. You
> > can find it in the mail from Guenther Roeck:
> >    http://www.mail-archive.com/linux-input@vger.kernel.org/msg00646.html
> 
> If you guys could get that merged into 3.6 I would appreciate it.
> 
Yes, that would be great. I don't recall seeing an e-mail from Dmitry accepting
it, though.

Guenter
