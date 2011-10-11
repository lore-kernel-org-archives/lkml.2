Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751250Ab1JKVel (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 17:34:41 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:46595 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751183Ab1JKVei (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 17:34:38 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Ravishankar Karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
Cc: gregkh@suse.de, wfp5p@virginia.edu, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] Staging: comedi: fix printk and line over 80
In-Reply-To: Your message of "Mon, 10 Oct 2011 19:28:53 +0530."
             <1318255133-6986-2-git-send-email-ravishankar.km@greenturtles.in>
From: Valdis.Kletnieks@vt.edu
References: <1318255133-6986-1-git-send-email-ravishankar.km@greenturtles.in>
            <1318255133-6986-2-git-send-email-ravishankar.km@greenturtles.in>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1318368870_2766P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 11 Oct 2011 17:34:30 -0400
Message-ID: <21386.1318368870@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Junkmail-Status: score=10/50, host=vivi.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020202.4E94B668.0085,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1318368870_2766P
Content-Type: text/plain; charset=us-ascii

On Mon, 10 Oct 2011 19:28:53 +0530, Ravishankar Karkala Mallikarjunayya said:
> This patch fixes a  printk and line over 80 charcter found by the
> checkpatch.pl tool

> @@ -503,7 +512,7 @@ static int probe(struct comedi_device *dev, const struct comedi_devconfig *it)
>  		}
>  	}
>  
> -	printk("cb_pcimdda: No supported ComputerBoards/MeasurementComputing "
> +	pr_err("cb_pcimdda: No supported ComputerBoards/MeasurementComputing "
>  	       "card found at the requested position\n");
>  	return -ENODEV;
>  }

As long as we're changing this code, should we be splicing the two parts of the
string back together?  (And yes, that *does* trump the 80-col rule)

--==_Exmh_1318368870_2766P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFOlLZmcC3lWbTT17ARAivaAKCVEzhRaU3UIO7g7trNS8QVwYaDqgCg+1eo
/ifse6PurHRJCORlRo6Tz94=
=CkUw
-----END PGP SIGNATURE-----

--==_Exmh_1318368870_2766P--

