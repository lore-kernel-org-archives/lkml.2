Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757604Ab0HJMdm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 08:33:42 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:61435 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757542Ab0HJMdf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 08:33:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=Lihb+uzYtsisuoYH3bbT81ArxOYqawta5MbohDA5KOMPX9u8XVPKdsKpN9iFY/aojN
         mOnULFMVwvj9h3tzLiS8E4KywoqSv6Nf34U5+vYzTYEal2K9ED7rK5q/npfHACKW0Ajk
         FXgEMMUgp4En1VJN0u+54rhooQ/7Jj3XoRCuA=
Date: Tue, 10 Aug 2010 15:38:07 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Len Brown <lenb@kernel.org>
Cc: Lin Ming <ming.m.lin@intel.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: BUG: scheduling while atomic: swapper/0/0x10000002
Message-ID: <20100810123807.GA5338@swordfish.minsk.epam.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="82I3+IH0IqGh5yIs"
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--82I3+IH0IqGh5yIs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello,

Hardware: ACER Aspire 5741G
kernel: 2.6.35-git9-06241-g2ba110e-dirty

[    0.003982] ACPI: Core revision 20100702
[    0.010045] BUG: scheduling while atomic: swapper/0/0x10000002
[    0.010140] no locks held by swapper/0.
[    0.010219] Modules linked in:
[    0.010356] Pid: 0, comm: swapper Not tainted 2.6.36-rc0-git9-06241-g2ba110e-dirty #99
[    0.010455] Call Trace:
[    0.010535]  [<ffffffff8102e368>] __schedule_bug+0x72/0x77
[    0.010622]  [<ffffffff8136b010>] schedule+0xdc/0x8f2
[    0.010707]  [<ffffffff810351ab>] __cond_resched+0x13/0x1f
[    0.010792]  [<ffffffff8136b945>] _cond_resched+0x29/0x30
[    0.010878]  [<ffffffff81242372>] acpi_ps_complete_op+0x2c6/0x2db
[    0.010965]  [<ffffffff8122de31>] ? acpi_ds_load1_end_op+0x51/0x249
[    0.011052]  [<ffffffff81242c3f>] acpi_ps_parse_loop+0x8b8/0xa55
[    0.011139]  [<ffffffff81061987>] ? trace_hardirqs_on+0xd/0xf
[    0.011224]  [<ffffffff81241dec>] acpi_ps_parse_aml+0x104/0x3c4
[    0.011310]  [<ffffffff8123fff9>] acpi_ns_one_complete_parse+0x125/0x142
[    0.011399]  [<ffffffff81220368>] ? acpi_os_signal_semaphore+0x5f/0x6f
[    0.011482]  [<ffffffff8124005f>] acpi_ns_parse_table+0x49/0x8e
[    0.011567]  [<ffffffff8123c42c>] acpi_ns_load_table+0x78/0x114
[    0.011652]  [<ffffffff81244f6e>] acpi_load_tables+0xa1/0x18e
[    0.011736]  [<ffffffff816b70f2>] acpi_early_init+0x6c/0xf7
[    0.011821]  [<ffffffff81692c1f>] start_kernel+0x3fd/0x40d
[    0.011905]  [<ffffffff816922aa>] x86_64_start_reservations+0xb1/0xb5
[    0.011990]  [<ffffffff816923a6>] x86_64_start_kernel+0xf8/0x107



	Sergey

--82I3+IH0IqGh5yIs
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iJwEAQECAAYFAkxhSC8ACgkQfKHnntdSXjSQZwP/QpbQNhQGow3VGagow8juUDur
sQhZEqb8DRxK5wuAvRLWl7iGUsaN5EHOTIlsC6Y7OAcATheap4kOeiss2uM+go7p
JUshOyLTFt8hQpULeLgio0HoUAPt4xJIRShhjR3duCOLQz74O6S7NEfB0q/qXIo7
6Ld0+A+RXfgkZ6fTLRc=
=9T/s
-----END PGP SIGNATURE-----

--82I3+IH0IqGh5yIs--
