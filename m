Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751482Ab1KMH11 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Nov 2011 02:27:27 -0500
Received: from b-pb-sasl-quonix.pobox.com ([208.72.237.35]:38939 "EHLO
	smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750910Ab1KMH1Z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Nov 2011 02:27:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=from:to:subject
	:cc:date:message-id:mime-version:content-type
	:content-transfer-encoding; q=dns; s=sasl; b=VkzzWI1CoiekSizOlfV
	PyDV06n9+BPd/RhzXLis1VPa4IUoZCK+lUFMwv/xZzb8or1UnmVUhNX52o3LRCXf
	/GiVlefLrPGiJGBJYywYeFvt+Xd3v3vqOmz0WOZWkMKiXLkzTs320Bsa39MkTo5o
	XrsQvRkvPV4chUyyKsxyvS6A=
From: Junio C Hamano <gitster@pobox.com>
To: git@vger.kernel.org
Subject: [ANNOUNCE] Git 1.7.8.rc2
cc: Linux Kernel <linux-kernel@vger.kernel.org>
Date: Sat, 12 Nov 2011 23:27:22 -0800
Message-ID: <7vzkg0o52d.fsf@alter.siamese.dyndns.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
X-Pobox-Relay-ID: EE5C1CC6-0DC8-11E1-B903-9DB42E706CDE-77302942!b-pb-sasl-quonix.pobox.com
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A release candidate Git 1.7.8.rc2 is available for testing.

Since rc0, we killed all known regressions. Because there won't be any
more new feature merged until the 1.7.8 final, it is a good time for the
coolest kids on the block to start using the upcoming release before
others do.

The release tarballs are found at:

    http://code.google.com/p/git-core/downloads/list

and their SHA-1 checksums are:

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

b1cb030dee2b9ae024f4076fe5fadfea43edec4e  git-1.7.8.rc2.tar.gz
cd30ce92f9518920ff8f9cdde0a8da5c856f6193  git-htmldocs-1.7.8.rc2.tar.gz
97d72c0c56e557eb3f11b9a3dcdb971e38eaee49  git-manpages-1.7.8.rc2.tar.gz
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBAgAGBQJOv287AAoJELC16IaWr+bLGJwP/1ZL+9NcBiIWshqxrYaBACF6
dgLsK1M7iJBn95ye6xBp57uPeLGK9iv5qLvo5Wxoog8raWgceR3qXjZL3snfYlLO
Hz2P8Zb9EF80QfVs7RjkQYAJRaT/WzbSxoQF/ZUXHyLk2BHpw6YfYA0Vj0JJZ72l
bCYMnppi18uxLuUyf6/0ftlkadxv3L58VIaNWAp8NwuLuskucx64LZgYzwkaRFfO
YNWgV0zwimK+9SF/gnQ5cw55GCurs69HWoDVLJbnQuJbjiU3Kl9jehYBwTo/rPSn
vo03Foh3mV6u3DTovZARLF54goJvvc+JKKkFAdeY+dNKLdZQRdO+hrldGTeGKxVk
XissJxmsHm/DkXc15yIPu+iV5wmAXVc8BpTzK1NgleuOyz2qnvVrmY+ZOVQfM1BA
4zS6PMp/sgEJa6ybmwXuYY/JpJlgmEBsDk6MJOJ8RKt+q0qovB+2ltMJbFpqVnQR
VEswTvhBOmUSfKhiY68UmqE4H6vmSO5yOmo1VQKgCKzN7glcG/3wpIHNK9+QW9yE
eOQMSDdBQGGgzz7Y+bVwpbOpSUsc49MYit8T9wx/haNNCA3Fud1UUKbT+060/zQw
Tgv2gi/6L/vCcDhj7oersNYfpgilggYBeiADKsI1fw6SHzBpbWblJZTtjr1yplaZ
YG+o9yPd2EwA2tkosG51
=hXu/
-----END PGP SIGNATURE-----

Also the following public repositories all have a copy of the v1.7.8.rc2
tag and the master branch that the tag points at:

  url = git://repo.or.cz/alt-git.git
  url = https://code.google.com/p/git-core/
  url = git://git.sourceforge.jp/gitroot/git-core/git.git
  url = git://git-core.git.sourceforge.net/gitroot/git-core/git-core
  url = https://github.com/gitster/git

----------------------------------------------------------------

Changes since v1.7.8-rc1 are as follows:

Felipe Contreras (1):
      remote: fix remote set-url usage

Jeff King (1):
      docs: don't mention --quiet or --exit-code in git-log(1)

Junio C Hamano (5):
      remote: fix set-branches usage
      docs: Update install-doc-quick
      Git 1.7.7.3
      Update draft release notes to 1.7.8
      Git 1.7.8-rc2

Liu Yuan (1):
      mktree: fix a memory leak in write_tree()

SZEDER Gábor (1):
      completion: don't leak variable from the prompt into environment

