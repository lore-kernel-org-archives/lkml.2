Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755957Ab1CQW4J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 18:56:09 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:35154 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755196Ab1CQW4H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 18:56:07 -0400
Date: Thu, 17 Mar 2011 22:56:03 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Tony Luck <tony.luck@gmail.com>
Cc: Xiaotian Feng <xtfeng@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: Some fixes for pstore (Was Re: [git pull] mnt_devname queue)
Message-ID: <20110317225603.GD22723@ZenIV.linux.org.uk>
References: <20110316235608.GY22723@ZenIV.linux.org.uk>
 <AANLkTimF9ExskxBmebk7X2=g5S6OK5vAa05G1cgeVVCP@mail.gmail.com>
 <20110317072344.GZ22723@ZenIV.linux.org.uk>
 <AANLkTin=5jSzZKXLL=A+dbRn1jB+tPg56LmjthzC02ui@mail.gmail.com>
 <20110317104434.GB22723@ZenIV.linux.org.uk>
 <4d827eae305473e2bf@agluck-desktop.sc.intel.com>
 <20110317224252.GC22723@ZenIV.linux.org.uk>
 <AANLkTim5pj0J4VaYRzK8_8fpb0=hO5yxhAL48egiTE2e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTim5pj0J4VaYRzK8_8fpb0=hO5yxhAL48egiTE2e@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 17, 2011 at 03:48:13PM -0700, Tony Luck wrote:
> On Thu, Mar 17, 2011 at 3:42 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> >> + ? ? memcpy(private->data, data, size);
> >> + ? ? inode->i_size = private->size = size;
> >>
> >> ? ? ? inode->i_private = private;
> >
> > Better move that before d_add()
> 
> Will do.
> 
> > *blink*
> > ? ? ? ?if (IS_ERR(root))
> > ? ? ? ? ? ? ? ?return root;
> > ? ? ? ?return root;
> >
> > ... or am I misreading the patch?
> 
> Your patch reading skills are fine ... the code deserves more than a *blink*.
> Will fix.

Send the updated patch my way, please.
