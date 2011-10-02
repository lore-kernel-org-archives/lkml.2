Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753857Ab1JBSMS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Oct 2011 14:12:18 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:43083 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753768Ab1JBSMK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Oct 2011 14:12:10 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: kernel.org status: establishing a PGP web of trust
Date: Sun, 2 Oct 2011 20:14:27 +0200
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc8+; KDE/4.6.0; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@suse.de>
References: <4E8655CD.90107@zytor.com> <201110021354.57995.rjw@sisk.pl> <4E88A537.4010008@zytor.com>
In-Reply-To: <4E88A537.4010008@zytor.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201110022014.27549.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, October 02, 2011, H. Peter Anvin wrote:
> On 10/02/2011 04:54 AM, Rafael J. Wysocki wrote:
> > On Sunday, October 02, 2011, H. Peter Anvin wrote:
> > 
> > Hmm.  That doesn't seem very practical if someone doesn't live close
> > to any other core kernel developers.
> > 
> 
> You probably know enough people (including myself) that would be willing
> to sign your key over the phone.  That's part of giving yourself
> sufficient time.

Well, then I propose that people create two new key pairs instead of
just one and take both of them to the KS for signing.  Afterwards, one
of them will be used for development and the other one's private key
will be kept in a safe place (without any online access), so it can be
used readily if the first pair is lost or compromised somehow.

Perhaps the second pair should have a longer life time.

> > What number of signatures on the key will be regarded as sufficient?
> > 
> >> We can work out specific details at KS.
> > 
> > Well, the KS is going to be busy time this year I suppose. :-)
> > What about people who haven't been invited to the KS?
> 
> Well, KS is still a place where we can discuss these kinds of policies;
> we can't be a perfect democracy and in fact have never even attempted to.

That doesn't seem to address my question directly.  Never mind. :-)

FYI, I am going to keep my current tree at github up to date even after
kernel.org has become operational again.  If every tree Linus pulls from
is hosted in two different locations, so that they can be used for double
checking the tree's integrity, that will improve the security of data
we want to protect much more than making access to kernel.org alone so
much more difficult.

Thanks,
Rafael
