Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934479Ab1JEL5Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 07:57:25 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:54423 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934221Ab1JEL5Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 07:57:24 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Borislav Petkov <bp@alien8.de>
Cc: "K.Prasad" <prasad@linux.vnet.ibm.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-kernel@vger.kernel.org, crash-utility@redhat.com,
        kexec@lists.infradead.org, Vivek Goyal <vgoyal@redhat.com>,
        Andi Kleen <andi@firstfloor.org>, "Luck, Tony" <tony.luck@intel.com>,
        anderson@redhat.com, tachibana@mxm.nes.nec.co.jp,
        oomichi@mxs.nes.nec.co.jp
Subject: Re: [Patch 1/4][kernel][slimdump] Add new elf-note of type NT_NOCOREDUMP to capture slimdump
In-Reply-To: Your message of "Wed, 05 Oct 2011 09:31:11 +0200."
             <20111005073111.GA13478@liondog.tnic>
From: Valdis.Kletnieks@vt.edu
References: <20111003070735.GJ2223@in.ibm.com> <20111003073203.GA22694@in.ibm.com> <m162k64c7w.fsf@fess.ebiederm.org> <20111003120336.GK2223@in.ibm.com> <20111004063440.GB5723@liondog.tnic> <20111005070728.GA2235@in.ibm.com>
            <20111005073111.GA13478@liondog.tnic>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1317815746_4646P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 05 Oct 2011 07:55:46 -0400
Message-ID: <26571.1317815746@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Junkmail-Status: score=10/50, host=zidane.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A02020A.4E8C45C9.00F3,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1317815746_4646P
Content-Type: text/plain; charset=us-ascii

On Wed, 05 Oct 2011 09:31:11 +0200, Borislav Petkov said:
> On Wed, Oct 05, 2011 at 12:37:28PM +0530, K.Prasad wrote:

> > True. Like stated by me earlier, there could be two possible outcomes
> > from capturing memory dump in such cases - they're either dangerous or
> > doesn't make sense.
>
> Why, in the second example the only corruption is to the L2 cache so
> your memory image is intact. Why wouldn't you want to capture a memory
> dump then? It is business as usual in that case.

I'll bite.  What's the use case for bothering to capture a memory dump when
you're looking at an MCE that indicates L2 cache corruption?  What additional
useful information could you possibly get from the dump?


--==_Exmh_1317815746_4646P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFOjEXCcC3lWbTT17ARAj9nAJsGN0yVYafcSY24KTP44oUK2wJbngCgqOxB
B8QxThIPMkyi8LSxEv6vQsY=
=RFHN
-----END PGP SIGNATURE-----

--==_Exmh_1317815746_4646P--

