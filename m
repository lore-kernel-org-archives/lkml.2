Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754057Ab1IHAxl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 20:53:41 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:47681 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751347Ab1IHAxj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 20:53:39 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>, agruen@kernel.org,
        bfields@fieldses.org, akpm@linux-foundation.org, dhowells@redhat.com,
        linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        LSM <linux-security-module@vger.kernel.org>
Subject: Re: [PATCH -V6 00/26] New ACL format for better NFSv4 acl interoperability
In-Reply-To: Your message of "Mon, 05 Sep 2011 15:42:17 PDT."
             <4E655049.6060507@schaufler-ca.com>
From: Valdis.Kletnieks@vt.edu
References: <1315243548-18664-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
            <4E655049.6060507@schaufler-ca.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1315442770_5805P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 07 Sep 2011 20:46:11 -0400
Message-ID: <108028.1315442771@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Junkmail-Status: score=10/50, host=steiner.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020207.4E681057.0037,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1315442770_5805P
Content-Type: text/plain; charset=us-ascii

On Mon, 05 Sep 2011 15:42:17 PDT, Casey Schaufler said:
> On 9/5/2011 10:25 AM, Aneesh Kumar K.V wrote:
> > The following set of patches implements VFS and ext4 changes needed to implement
> > a new acl model for linux. Rich ACLs are an implementation of NFSv4 ACLs,
> > extended by file masks to fit into the standard POSIX file permission model.
> > They are designed to work seamlessly locally as well as across the NFSv4 and
> > CIFS/SMB2 network file system protocols.
>
> POSIX ACLs predate the LSM and can't be done as an LSM due to
> the interactions between mode bits and ACLs as defined by the
> POSIX DRAFT specification. Is there a reason that "rich" ACLs
> can not be done as an LSM?

Well, if it was done as an LSM, it would mean that if I wanted to build a
system where I have a few hundred terabytes of disk exported via Samba, and I
wanted Samba to save the CIFS permission ACL, I couldn't also run Selinux or
SMACK or anything like that - unless somebody actually snuck in the "LSMs are
stackable" patch while I wasn't looking?


--==_Exmh_1315442770_5805P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFOaBBScC3lWbTT17ARAiknAJ9BidK9ESj7Gg5fL0HGU9EmbWYaEwCgtr+i
Fo7Zv7VVnLAYeXHB39NivRM=
=g+Ps
-----END PGP SIGNATURE-----

--==_Exmh_1315442770_5805P--

