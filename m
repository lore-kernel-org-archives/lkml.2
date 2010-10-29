Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932866Ab0J2UlJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 16:41:09 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:37986 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932514Ab0J2UlD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 16:41:03 -0400
Message-ID: <4CCB3158.9010406@kernel.org>
Date: Fri, 29 Oct 2010 13:40:56 -0700
From: "J.H." <warthog9@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12) Gecko/20100907 Fedora/3.0.7-1.fc12 Lightning/1.0b2pre Thunderbird/3.0.7
MIME-Version: 1.0
To: users@kernel.org, linux-kernel <linux-kernel@vger.kernel.org>
Subject: [KORG] Master / hera upgrade & downtime announcement
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.3 (shards.monkeyblade.net [198.137.202.13]); Fri, 29 Oct 2010 13:41:00 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Afternoon Everyone,

Thought I'd give everyone a quick heads up, that since Kernel Summit
starts on the 1st of November, which means I've got my one chance to do
system maintenance on master / hera for the year.

I'm expecting to do the upgrade on the 1st itself, likely start time
will be around Mon Nov  1 19:00:00 UTC 2010, and I'm hoping for the
entire downtime to take no longer than 2 hours.

Things that are going to happen during the upgrade:

	- OS getting upgraded to Fedora 13
		w/ custom kernel to solve XFS and disable IMA
	- Hardware change
		Google and HP have been very generous enough to
		get us a new machine for the master / hera machine.
		The new machine is a dual, quad core Xeon X5550 box
		with 32G of ram.  Beyond that it nearly identical to the
		current machine.

		The current machine will become a 'live' backup machine
		that will sync semi-continuously, and be available
		should catastrophic failure of master / hera occur.

Think that's the main big changes.  I'm already working on the upgrade
since I have multiple boxes to do this with, and things are looking good
so far.

As a note the start time is estimated, if there is a major change to the
start time I will let everyone know.

As always, if you have questions, comments or concerns please e-mail me
or ftpadmin@kernel.org

- - John 'Warthog9' Hawley
Chief Kernel.org Administrator
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Fedora - http://enigmail.mozdev.org/

iEYEARECAAYFAkzLMVgACgkQ/E3kyWU9did9wACeO0nlEtiX52u6pD3slKtqZ61M
ZTgAn3TLwks7sT5ovpf9X6/WSbK7+hcz
=gIkm
-----END PGP SIGNATURE-----
