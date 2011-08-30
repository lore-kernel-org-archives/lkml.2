Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753456Ab1H3LE0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 07:04:26 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:35876 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753417Ab1H3LEX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 07:04:23 -0400
From: Christoph Egger <siccegge@cs.fau.de>
To: vamos-dev@i4.informatik.uni-erlangen.de, linux-kernel@vger.kernel.org
Organization: Privat
Date: Tue, 30 Aug 2011 13:04:45 +0200
Message-ID: <8739gjf9de.fsf@hepworth.siccegge.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha512; protocol="application/pgp-signature"
X-SA-Exim-Connect-IP: 10.70.1.67
X-SA-Exim-Mail-From: christoph@christoph-egger.org
Subject: [ANNOUNCE] undertaker 1.2
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:51:10 +0000)
X-SA-Exim-Scanned: Yes (on sol.asgard)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

The VAMOS team is pleased to announce the release of the undertaker tool
version 1.2. The tool is a result of the VAMOS[1] research project.

Please visit our project site at:
http://vamos.informatik.uni-erlangen.de/trac/undertaker

What is new in undertaker 1.2
=2D----------------------------

 * Coverage support: Generate partial (Kconfig) configurations to cover
   each conditional block [3]
 * Rewritten Kconfig constraints extractor in python improving support
   for some kconfig constructs
 * Improved #define/#undef support
 * The analysis is no longer restricted to CPP Macros that start with
   CONFIG_ (regex can be overriden in the configuration model)

What is undertaker?
=2D------------------
The undertaker is a tool for static code analysis for code with C
preprocessor directives, which can be used in various modes. The most
prominent one checks every single preprocessor block within the file
whether it can be selected or deselected, which in many cases is a great
asset for code maintenance.

Some preprocessor blocks are only seemingly conditional. In many cases,
it turns out that additional constraints from the project's
configuration model causes such conditional blocks to be in fact
unconditionally selected or unselected. We call such block "dead" and
"undead" conditional blocks.

Undertaker provides tools to extract the configuration model from the
Linux configuration tooling Kconfig and to perform this check on whole
source trees.

What undertaker is not?
=2D----------------------
It isn't an automatic patch generator. Because of peculiarities in the
Kconfig semantics, (ignored) coding guidelines and simply engineering
issues, the reports might contain false negatives. Note that our
philosophy is that we prefer false negatives over false positives, i.e.,
we prefer to miss reports than reports that are no issue at all.

What else can i do with undertaker?
=2D----------------------------------
You can extract boolean formulas (with or without model) for a given
line of sourcecode in a file or for a given symbol. There is also an
integration for emacs for interactive browsing of block and symbol
preconditions.

Additional uses are currently under development.

[1] http://www4.informatik.uni-erlangen.de/Research/VAMOS/
[2] Configuration Coverage in the Analysis of Large-Scale System
    Software, Reinhard Tartler et. al., publication accepted for the
    PLOS Workshop 2011

=2D-=20
Christoph Egger
9FED 5C6C E206 B70A 5857  70CA 9655 22B9 D49A E731
Debian Developer | Lisp Hacker | CaCert Assurer

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCgAGBQJOXMPNAAoJEKv/7bJACMb52JkP+gMJHAcRCCf1NUzcgxzJn8RG
QnZ2abTzoiLQ0p3u/L9JrhJpqcuZO5U1n76dTt9/w0hL4FKJ3a5SakM2U6n9N98d
VbgbhkbSOWy8KjumubOOsJwp9KWOr9jMWqyUxH5YuZ3aZ4CB6j6LXV9SKnYgdYbL
7I49XhCs4Xz0vRHAtrPV8xdVljzCCeLVMWVobnUgMp5G591SdEaohMXDQ6LeX7qn
6vvnTIfK6KdVSYJb4Lq+YlK+ZO3VBvOGDCWVYLoLRQ4MGhJwdvQkCwH6Aa8peGjx
+SyA2omiRel+RjgSJnVMcy1PuROV862KpiMTWvAJ9vYtEgq2rGwhHAl3GDoEceu3
bXzUGGTKhGXcK27YTwNcX5ieU8bWhn7s1VQFtLnC0OMovno5pkUY1dscreg35LGe
jqTO4GtdTn/uV9wscCewY1v8Nv4v5K2HY5dt9rupNkpB7nuv2COYeSBc3ZBQGWXw
Hd4d+8GpciTLShslWqY+xyMcnIpt+Q+SnSKBQ6gTBxcx4/DqrFqyEVelBlzZ2r2t
/QhtN4hWb3dUx/pJv4HXFbYpgPd4kFeY24n5Y33xYXNIr+mZz/KdABvkKq66B9Hz
vNlgwnJQBKyWjI97T/hJNhMRHzwFSt+LZ5hhbaraxuX28alzIV3dmOO0jicjnyxV
pEPX8ID18b0+AYZto7In
=PbT2
-----END PGP SIGNATURE-----
--=-=-=--
