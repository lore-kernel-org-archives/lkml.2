Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755374Ab0KUTIK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Nov 2010 14:08:10 -0500
Received: from lennier.cc.vt.edu ([198.82.162.213]:51808 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751578Ab0KUTII (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Nov 2010 14:08:08 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Mark Lord <kernel@teksavvy.com>
Cc: Chris Mason <chris.mason@oracle.com>,
        James Bottomley <james.bottomley@suse.de>,
        Christoph Hellwig <hch@infradead.org>, Matthew Wilcox <matthew@wil.cx>,
        Josef Bacik <josef@redhat.com>, Lukas Czerner <lczerner@redhat.com>,
        tytso <tytso@mit.edu>, linux-ext4 <linux-ext4@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        sandeen <sandeen@redhat.com>
Subject: Re: [PATCH 1/2] fs: Do not dispatch FITRIM through separate super_operation
In-Reply-To: Your message of "Fri, 19 Nov 2010 09:53:52 EST."
             <4CE68F80.7000607@teksavvy.com>
From: Valdis.Kletnieks@vt.edu
References: <1290065809-3976-1-git-send-email-lczerner@redhat.com> <20101118130630.GJ6178@parisc-linux.org> <20101118134804.GN5618@dhcp231-156.rdu.redhat.com> <20101118141957.GK6178@parisc-linux.org> <20101118142918.GA18510@infradead.org> <1290100750.3041.72.camel@mulgrave.site> <4CE59C9E.6050902@teksavvy.com> <1290177488-sup-6540@think>
            <4CE68F80.7000607@teksavvy.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1290366424_7222P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Sun, 21 Nov 2010 14:07:04 -0500
Message-ID: <36056.1290366424@localhost>
X-Mirapoint-Received-SPF: 128.173.34.98 localhost Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=dagger.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A020202.4CE96DD9.000C,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-09-22 00:05:22,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1290366424_7222P
Content-Type: text/plain; charset=us-ascii

On Fri, 19 Nov 2010 09:53:52 EST, Mark Lord said:
> On 10-11-19 09:40 AM, Chris Mason wrote:
> >
> > We've been told that online and constant trimming is the default in
> > windows7.   The ssds are most likely to just start ignoring the trims
> > they can't service efficiently.
> 
> Win7 collects multiple TRIM ranges over time and batches them as single TRIMs
> (as reported to me by an SSD vendor who traced it with a SATA analyzer,
>   and who also apparently has "inside info").

What should happen if we have (for instance) a "collect 64 trims at a time" policy,
and the system crashes at trim number 47? (Probably not an issue if you're
doing non-deterministic trim, but is an exposure if you're relying on deterministic
trim for security reasons)

--==_Exmh_1290366424_7222P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFM6W3YcC3lWbTT17ARAp32AKCjjlYzzTYXtVHem/U0SuuG3N7NZwCgxkFo
9gYTPHfjAXC4eXLbjpea09Y=
=FpSi
-----END PGP SIGNATURE-----

--==_Exmh_1290366424_7222P--

