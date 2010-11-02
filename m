Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754688Ab0KBSTM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Nov 2010 14:19:12 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:48828 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753541Ab0KBSTC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Nov 2010 14:19:02 -0400
Message-ID: <4CD05610.2000108@kernel.org>
Date: Tue, 02 Nov 2010 11:18:56 -0700
From: "J.H." <warthog9@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12) Gecko/20100907 Fedora/3.0.7-1.fc12 Lightning/1.0b2pre Thunderbird/3.0.7
MIME-Version: 1.0
To: users@kernel.org, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [kernel.org users] [KORG] Master / hera	upgrade	&	downtime	announcement
References: <4CCB3158.9010406@kernel.org> <4CCF24F0.5050704@kernel.org>	<4CCF3AA1.8050804@kernel.org> <4CCF4AB3.8070505@kernel.org>
In-Reply-To: <4CCF4AB3.8070505@kernel.org>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.3 (shards.monkeyblade.net [198.137.202.13]); Tue, 02 Nov 2010 11:18:59 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Latest update

> I'm going to do a full resync of /pub - this will squash anything that
> was there with what was present around 1900 UTC on Nov 1st.  Home dirs,
> mail, etc are going to have to get dealt with on a per-case basis.

/pub was reset last night, which basically means anything that may have
been pushed from about 19:00 Nov 1 UTC to 02:56 Nov 2 UTC could be
squashed and will need to be re-pushed, but this should clean up the
vast majority of the issues there were present there.

This will likely mean a few more extra tip e-mails for those of you on
that mailing list (again sorry about that), and possibly some other
e-mails from various cron scripts that individual users are running and
maintaining.

> I might just setup an NFS mount across the two machines and let people
> snag what they need on their own with respect to that.

I've gone ahead and created /home/restore - it has have a copy of the
home directory as it existed around 19:00 Nov 1 UTC.  I will garauntee
it being around until Nov 30th.  I will need to delete it sometime after
that, mainly because of the backup bloat it will cause.  If you made
changes to your home directory between Sept. 29th and Nov 1, you will
need to deal with the merging of the data manually.

With respect to those users who use IMAP against the machine I've copied
your INBOX mail spools to /home/restore/MAILSPOOL.  The easiest way to
deal with merging this in with your current inbox is toe copy your spool
to your ~/mail directory, load up thunderbird and copy all the mail from
the old inbox to your current inbox and then use something like "Remove
Duplicate Messages (alternate)" to eliminate the duplicates.

That should be everything.  I'm going to keep poking around trying to
find anything else that's off kilter, but I haven't seen any new reports
of anything else amiss yet and things seem to be working otherwise.  So
if you see something amiss, please let me know ASAP.

- - John 'Warthog9' Hawley
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Fedora - http://enigmail.mozdev.org/

iEYEARECAAYFAkzQVhAACgkQ/E3kyWU9dic1ZwCeL0IdwITS2lYcmQhmOK/kevk5
l2wAnAzfynrADpgv+I7KL0rvQQU8Fmxe
=6g1w
-----END PGP SIGNATURE-----
