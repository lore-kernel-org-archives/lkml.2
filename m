Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753543Ab2ATOyJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 09:54:09 -0500
Received: from mail.opencsw.org ([82.220.5.51]:56770 "EHLO mail.opencsw.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752646Ab2ATOyH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 09:54:07 -0500
X-Greylist: delayed 656 seconds by postgrey-1.27 at vger.kernel.org; Fri, 20 Jan 2012 09:54:07 EST
Date: Fri, 20 Jan 2012 15:43:09 +0100
From: Attila Kinali <attila@kinali.ch>
To: Karel Zak <kzak@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        util-linux@vger.kernel.org
Subject: Re: /etc/fstab.d yes or not
Message-Id: <20120120154309.3ae5f9e4a8f55c477dc423ab@kinali.ch>
In-Reply-To: <20120120140444.GC13157@x2.net.home>
References: <20120120140444.GC13157@x2.net.home>
Organization: GEHIRN
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.8; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Jan 2012 15:04:44 +0100
Karel Zak <kzak@redhat.com> wrote:

>  I'd like to add support for /etc/fstab.d to libmount. The library is
>  currently used by mount, umount and mount.nfs. The goal is to use it
>  on more places.
> 
>  The /etc/fstab.d directory has been requested by people who maintains
>  large number of mountpoints etc.
> 
>  The directory is not replacement for /etc/fstab, it's additional place
>  where you can describe your filesystems.

It might not be my place to say anthing about this, as I am just
a mere mortal .... 

But I'd like to express my concerns on this. In the years i've been
using Linux, the system has become a very complex beast. While in the 
beginning I could just dig trough a couple of scripts to figure out
how a certain system worked, or more likely why it didn't work...
nowadays i have to have knowledge of a dozen of complex interacting
daemons to figure out why gedit refuses to edit a simple text file.

Complexity is added everywhere, to make a few corner cases a little
bit more simple. Making it more difficult for the 99% who do
not care about these corner cases. This in turn makes Linux this
opaque system that only a handfull of selected can understand, who
invest their whole life to the understanding of its many subsystems.
If this continues like this, in a decade or two, Linux will become
like windows. A system nobody clearly understands, which somehow works,
but sometimes not.. and nobody knows why.

Hence, i would like to ask you to consider not adding /etc/fstab.d
unless there is a very good reason to do it. And "to make it simpler
for people who have a lot of mountpoints" is IMHO not a good reason.
How many mountpoints must one use that a single file becomes a problem?


			Attila Kinali

-- 
The trouble with you, Shev, is you don't say anything until you've saved
up a whole truckload of damned heavy brick arguments and then you dump
them all out and never look at the bleeding body mangled beneath the heap
		-- Tirin, The Dispossessed, U. Le Guin
