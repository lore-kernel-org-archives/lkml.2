Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755671Ab1DPOuy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Apr 2011 10:50:54 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:55061 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751672Ab1DPOuv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Apr 2011 10:50:51 -0400
Date: Sat, 16 Apr 2011 16:50:50 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Francis Moreau <francis.moro@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Kbuild: how to cleanly retrieve information compilation about
	the last build
Message-ID: <20110416145050.GA1124@merkur.ravnborg.org>
References: <BANLkTi=GXro_xEiRyzZY86kWM9duJ3KAUQ@mail.gmail.com> <BANLkTi=2aRu6x3uZtpMvPd2BSpYpkT5yfQ@mail.gmail.com> <20110416135912.GA1044@merkur.ravnborg.org> <BANLkTi=wdDsrV+ikoxLhnTpLhQTuVKW0mA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTi=wdDsrV+ikoxLhnTpLhQTuVKW0mA@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> BTW are the allowed flags documented somewhere ?
Some/most supported flags are documented in Dumentation/kbuild/kbuild.txt

> > If you on a regular basis need to pass flags on the command-line
> > then you likely are doing something odd as this is not the typical use.
> > So please reconsider what you are doing.
> 
> Ok, if I'm doing something wrong, I'd like to be corrected.
> 
> What's wrong with passing those flags for example:
> 
>   $ make ARCH=arm CROSS_COMPILE=arm-linux
> 
> or
> 
>    $ make CC=distcc
> 
> ?
Both examples are perfectly OK. From your previous posting it
looked like you passed flags that influenced how the kernel
was built (CCFLAGS) and it did not look like you had cross-compile
nor distcc in mind - hence my comment.

	Sam
