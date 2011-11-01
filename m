Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754392Ab1KAMfy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 08:35:54 -0400
Received: from serv04.lahn.de ([213.239.197.57]:45048 "EHLO serv04.lahn.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754154Ab1KAMfx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 08:35:53 -0400
Date: Tue, 1 Nov 2011 13:35:39 +0100
From: Michael Leun <ml@newton.leun.net>
To: richard -rw- weinberger <richard.weinberger@gmail.com>
Cc: linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
        nigel@tuxonice.net
Subject: Re: What about bugzilla.kernel.org / Bug 37142 / Tuxonice developer
 going to quit development
Message-ID: <20111101133539.1933dc6c@xenia.leun.net>
In-Reply-To: <CAFLxGvybSStaRaS1ig9=h++LHx7EXzo4_48V4oix9mdPvRHFaw@mail.gmail.com>
References: <20111101111420.1667f3aa@xenia.leun.net>
	<CAFLxGvxeofy58Zuo9rGuXsiQMitJp890T0vwkDzoLHQ3im63ZA@mail.gmail.com>
	<20111101131849.668e0115@xenia.leun.net>
	<CAFLxGvybSStaRaS1ig9=h++LHx7EXzo4_48V4oix9mdPvRHFaw@mail.gmail.com>
Organization: Not Organized
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.22.1; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Nov 2011 13:20:59 +0100
richard -rw- weinberger <richard.weinberger@gmail.com> wrote:

> > So, you might want to try if you can cure your dying HW with some
> > tuxonice ;-)
> 
> I've never used tuxonice. What makes it so special?

A few years ago, at least for me, it was the first really usable suspend
to disk solution working almost out of the box.


>From linux/Documentation/power/tuxonice.txt (some of that seems to be
outdated with the current in kernel implementation):


4. Why not just use the version already in the kernel?

   The version in the vanilla kernel has a number of drawbacks. The most
   serious of these are:
        - it has a maximum image size of 1/2 total memory;
        - it doesn't allocate storage until after it has snapshotted
   memory. This means that you can't be sure hibernating will work
   until you see it start to write the image;
        - it does not allow you to press escape to cancel a cycle;
        - it does not allow you to press escape to cancel resuming;
        - it does not allow you to automatically swapon a file when
          starting a cycle;
        - it does not allow you to use multiple swap partitions or
   files;
        - it does not allow you to use ordinary files;
        - it just invalidates an image and continues to boot if you
          accidentally boot the wrong kernel after hibernating;
        - it doesn't support any sort of nice display while hibernating;
        - it is moving toward requiring that you have an
   initrd/initramfs to ever have a hope of resuming (uswsusp). While
   uswsusp will address some of the concerns above, it won't address
   all of them, and will be more complicated to get set up;
        - it doesn't have support for suspend-to-both (write a
   hibernation image, then suspend to ram; I think this is known as
   ReadySafe under M$).



-- 
MfG,

Michael Leun

