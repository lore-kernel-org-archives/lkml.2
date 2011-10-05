Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934903Ab1JEQCP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 12:02:15 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:43558 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758030Ab1JEQCO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 12:02:14 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Vivek Goyal <vgoyal@redhat.com>
Cc: "K.Prasad" <prasad@linux.vnet.ibm.com>, Borislav Petkov <bp@alien8.de>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-kernel@vger.kernel.org, crash-utility@redhat.com,
        kexec@lists.infradead.org, Andi Kleen <andi@firstfloor.org>,
        "Luck, Tony" <tony.luck@intel.com>, anderson@redhat.com,
        tachibana@mxm.nes.nec.co.jp, oomichi@mxs.nes.nec.co.jp
Subject: Re: [Patch 1/4][kernel][slimdump] Add new elf-note of type NT_NOCOREDUMP to capture slimdump
In-Reply-To: Your message of "Wed, 05 Oct 2011 11:52:17 EDT."
             <20111005155217.GE30146@redhat.com>
From: Valdis.Kletnieks@vt.edu
References: <20111003070735.GJ2223@in.ibm.com> <20111003073203.GA22694@in.ibm.com> <m162k64c7w.fsf@fess.ebiederm.org> <20111003120336.GK2223@in.ibm.com> <20111004063440.GB5723@liondog.tnic> <20111005070728.GA2235@in.ibm.com> <20111005073111.GA13478@liondog.tnic> <20111005094727.GB7485@in.ibm.com>
            <20111005155217.GE30146@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1317830438_2599P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 05 Oct 2011 12:00:38 -0400
Message-ID: <10327.1317830438@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Junkmail-Status: score=10/50, host=steiner.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020201.4E8C7F28.0109,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1317830438_2599P
Content-Type: text/plain; charset=us-ascii

On Wed, 05 Oct 2011 11:52:17 EDT, Vivek Goyal said:

> I am assuming that basic MCE error messages are available in kernel log. 

They're not in the kernel log if it's an MCE that causes the kernel to declare
a panic. There's some MCE's that you can retry the operation and continue, and
some that you can get away with poisoning a page, killing the process, and rest
of the system is OK.  But some you really need to roll over and die because you
can't guarantee kernel integrity anymore.

And at that point, those messages are never gonna make it to syslogd and onto
disk.


--==_Exmh_1317830438_2599P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFOjH8mcC3lWbTT17ARAgaLAKCFRXcqzTLI6xyllyVLc2NRAaLgVgCeMzDi
ukG1PwIQuODnxVXi/GOKe/0=
=4gHJ
-----END PGP SIGNATURE-----

--==_Exmh_1317830438_2599P--

