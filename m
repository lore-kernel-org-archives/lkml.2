Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755533Ab1ALTEt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 14:04:49 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:45595 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753654Ab1ALTEq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 14:04:46 -0500
Message-ID: <4D2DFB4B.5000204@kernel.org>
Date: Wed, 12 Jan 2011 11:04:43 -0800
From: "J.H." <warthog9@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Lightning/1.0b2pre Thunderbird/3.0.10
MIME-Version: 1.0
To: users@kernel.org, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [kernel.org users] [KORG] Master /	hera	upgrade	&	downtime	announcement
References: <4CCB3158.9010406@kernel.org>	<4CCF24F0.5050704@kernel.org>	<4CCF3AA1.8050804@kernel.org>	<4CCF4AB3.8070505@kernel.org> <4CD05610.2000108@kernel.org>
In-Reply-To: <4CD05610.2000108@kernel.org>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.3 (shards.monkeyblade.net [198.137.202.13]); Wed, 12 Jan 2011 11:04:43 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

>> I might just setup an NFS mount across the two machines and let people
>> snag what they need on their own with respect to that.
> 
> I've gone ahead and created /home/restore - it has have a copy of the
> home directory as it existed around 19:00 Nov 1 UTC.  I will garauntee
> it being around until Nov 30th.  I will need to delete it sometime after
> that, mainly because of the backup bloat it will cause.  If you made
> changes to your home directory between Sept. 29th and Nov 1, you will
> need to deal with the merging of the data manually.
> 
> With respect to those users who use IMAP against the machine I've copied
> your INBOX mail spools to /home/restore/MAILSPOOL.  The easiest way to
> deal with merging this in with your current inbox is toe copy your spool
> to your ~/mail directory, load up thunderbird and copy all the mail from
> the old inbox to your current inbox and then use something like "Remove
> Duplicate Messages (alternate)" to eliminate the duplicates.
> 
> That should be everything.  I'm going to keep poking around trying to
> find anything else that's off kilter, but I haven't seen any new reports
> of anything else amiss yet and things seem to be working otherwise.  So
> if you see something amiss, please let me know ASAP.

Just a quick heads up since we are now two+ months down the road from
this.  I'm going to wipe out /home/restore on Friday of this week.  If,
for whatever reason, you have not dealt with this yet please do so now
as the data will be removed from the system.  This is mainly to help
deal with a backup system that is happening and to eliminate the extra
overhead that the data is taking up.

Thanks!

- - John 'Warthog9' Hawley
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Fedora - http://enigmail.mozdev.org/

iEYEARECAAYFAk0t+0sACgkQ/E3kyWU9dieO4ACdGU31QR0UG4f52cqWq8FBBXlC
eyIAnRXHQWf5Z5uPp9GPmFcTOD/6VJWL
=Qhux
-----END PGP SIGNATURE-----
