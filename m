Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752832Ab0CSBNc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 21:13:32 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:34285 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751251Ab0CSBNb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 21:13:31 -0400
Message-ID: <4BA2CFB7.7070108@kernel.org>
Date: Thu, 18 Mar 2010 18:13:27 -0700
From: "J.H." <warthog9@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Lightning/1.0b2pre Thunderbird/3.0.1
MIME-Version: 1.0
To: users@kernel.org, linux-kernel <linux-kernel@vger.kernel.org>
Subject: [KORG] Availability of SSL on kernel.org
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.3 (shards.monkeyblade.net [198.137.202.13]); Thu, 18 Mar 2010 18:13:28 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Afternoon Everyone,

I would like to go ahead and announce the general availability of SSL
support for a number of the services on kernel.org! This should help
provide an additional level of security, in particular for our dynamic
content like the wiki's, patchwork and bugzilla.

The certificates have been very graciously donated and signed by Thawte,
and we at kernel.org greatly appreciate their support of Open Source!
These signed certificates make it trivial for our users to make use of
this additional layer of security, and alleviates a large amount of
support effort that self-signed certificates would have incurred.

	"Thawte is proud of its open source lineage. Providing free
	 certificates to community projects is just a small way of not
	 only supporting the community but returning the favor.  Please
	 spread the word."

Services that are now by default using SSL:

    * Bugzilla
    * Wikis
    * Account Requests
    * Patchwork

    These are using an HTTP redirect so you should need to do anything
    for these to just work.

Services that have can optionally use SSL:

    * www.kernel.org
    * boot.kernel.org
    * git.kernel.org
    * android.git.kernel.org

    Just use https vs. http, there is no automatic redirection for these

Services that DO NOT offer SSL:

    * mirrors.kernel.org

    These machines move a large amount of data to a large number of
    users and it would be difficult, and memory intensive, to provide
    SSL for this service.  I don't foresee enabling SSL for
    mirrors.kernel.org.

    * *.[us | [nl.|se.]eu | geo | all].kernel.org dns entries

    These would require too many distinct certificates to adequately
    cover, and are generally not user facing.  These still have
    the SSL certificates available to them, but the address will not
    match the CN in the certificate.

As always if you encounter problems, e-mail ftpadmin or catch us on IRC.
 I've done a fair amount of testing of this on my own - but due to the
large number of possible clients it's impossible for me to have tested
this from every possible angle.

- - John 'Warthog9' Hawley
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Fedora - http://enigmail.mozdev.org/

iEYEARECAAYFAkuiz7cACgkQ/E3kyWU9dicIAwCfQlTlSDEMn1GP++Cy7IFV9Oqi
MP4Aniu0hVPdXMopnAG/W/PtWd0aEDus
=pg6c
-----END PGP SIGNATURE-----
