Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752020Ab0KGHjS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Nov 2010 02:39:18 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:45512 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751507Ab0KGHjR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Nov 2010 02:39:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=jmOxBwyz319aCpqt0pphDxD99yKiEdGVf6rnM4NPsKgijyRR5aWGi387aLQFbdyBic
         HBWurd1AuNFiB2SFgukskt6KzfV8ovb2PgA9GyAf4D3O9s7yUrmtEgAa+vjcsfIqiC5g
         N3fK9qmds/r/C9sH82H+ueohX5/JIyMDqSHSc=
Date: Sun, 7 Nov 2010 15:42:13 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: JD <jd1008@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Question/help re: themake scripts in 2.6.36
Message-ID: <20101107074213.GL3046@hack>
References: <4CD63067.8010506@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CD63067.8010506@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 06, 2010 at 09:51:51PM -0700, JD wrote:
> I have compiled 2.6.36 (i686) without any problems.
> Since then, I have decided to change a couple of
> config variables (using xconfig).


You can use 'make oldconfig'.

> When done, running make all
> causes the make scripts to stop compilation after building
> a few objects, and spawn a shell.
> Since I have no idea what to do in that shell, I exit
> that shell, and the compilaton continues.
> This takes place 3 times before compilation is complete.
>


What? How can make spawn a shell...

Can you copy and paste what you see and what you get
from your terminal?

> Now, when I type make modules_install install,
> only modules_install is done. /boot does not get
> populated and /boot/grub/grub.conf is unchanged.
>
> The currently installed and running 2.6.36-1
> went through a similar scenario during build,
> but at least install did work.
> Now the install does not work.
> Befor the present build attempt,
> I had edited the Makefile to change the EXTRAVERSION to -2
> in order not to clobber the installed  2.6.36-1
>
> Could someone tell me what to do to force the install in /boot?
> /lib/modules does have 2.6.36-2.fc13.i686 fully populated.
>

Since you are using Fedora, you can try grubby or new-kernel-pkg.

-- 
Live like a child, think like the god.
 
