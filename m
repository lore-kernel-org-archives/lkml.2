Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752783Ab1JTUsL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 16:48:11 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:53136 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751394Ab1JTUsK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 16:48:10 -0400
Date: Thu, 20 Oct 2011 16:47:59 -0400
From: "Ted Ts'o" <tytso@mit.edu>
To: Phillip Lougher <phil.lougher@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, greg@kroah.com,
        linux-kernel@vger.kernel.org, phillip@lougher.demon.co.uk
Subject: Re: Procedural requirements for restoring kernel.org accounts
Message-ID: <20111020204759.GB16820@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	Phillip Lougher <phil.lougher@gmail.com>,
	"H. Peter Anvin" <hpa@zytor.com>, greg@kroah.com,
	linux-kernel@vger.kernel.org, phillip@lougher.demon.co.uk
References: <20111014152100.GA11717@kroah.com>
 <4E988564.40905@zytor.com>
 <CA+2-8GA-R3TETVLubOO8uMQq1a3-LmQ=STrXM1kf+8WbgfhTLQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+2-8GA-R3TETVLubOO8uMQq1a3-LmQ=STrXM1kf+8WbgfhTLQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 20, 2011 at 09:33:20PM +0100, Phillip Lougher wrote:
> 
> I notice a key signing has been announced for the KS
> (http://sites.google.com/site/kernelsummit2011/gpg-key-verification) @
> 4.30pm on Tuesday, open to all LCE attendees.   However, I'm sure I'm
> not the only one who doesn't get into Prague early enough to go to
> this.  So, will there be another key signing session held during the
> three days of LCE, and will the procedure mentioned in the link above
> ("If you would like to participate, please send an e-mail to
> prague-key-submission@googlegroups.com") apply too?

If you're not going to be able to make the key signing on Tuesday,
please don't bother to send your key to
prague-key-submission@googlegroups.com, since that won't do much good.

Instead, I would suggest that you use the script called gpg-key2ps,
which can be found in a package called pgp-tools (Fedora/Red Hat/SuSE)
or signing-party (Debian/Ubuntu), or from the source tree found at
http://pgp-tools.alioth.debian.org.

This will print out your keys multiple times on a piece of paper, so
you can cut them into paper strips.  There will be many kernel
developers staying the whole week.  You can ask them to sign your key,
and then hand them one of the strips of paper.  You will need to
convince them of your identity; this can be done with government
issued ID, although some kernel developers may not be comfortable
doing this since they might not know what a Welsh identity card or UK
passport might look like.  So some kernel developers may only sign a
key if they know you personally.  Other kernel developers are willing
to trust government issued ID (I've been around the world enough so I
know what a UK passport looks like :-).

Regards,

						- Ted
