Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751541Ab1KIBPf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 20:15:35 -0500
Received: from b-pb-sasl-quonix.pobox.com ([208.72.237.35]:42495 "EHLO
	smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750816Ab1KIBPe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 20:15:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=from:to:subject
	:cc:date:message-id:mime-version:content-type; q=dns; s=sasl; b=
	eLa1p5EUyv2fsK9X/z1oVRrBHsmQoC+lWaOkT8iCf/nLB0OptWccAlkjBgSz91wt
	sNpjKABSoYqQUW0qfJfTB7Q6/+lb9RcNt4r8nI/qhU2F81Lj9aBH9nxtyPVnMaCo
	RgkccoBUrlcrRlhJlvag162CEkpxKfYEtVyouNO2oxo=
From: Junio C Hamano <gitster@pobox.com>
To: git@vger.kernel.org
Subject: [ANNOUNCE] Git 1.7.7.3
cc: Linux Kernel <linux-kernel@vger.kernel.org>
Date: Tue, 08 Nov 2011 17:15:31 -0800
Message-ID: <7vsjlyw0y4.fsf@alter.siamese.dyndns.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Pobox-Relay-ID: 523E347E-0A70-11E1-9188-9DB42E706CDE-77302942!b-pb-sasl-quonix.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The latest maintenance release Git 1.7.7.3 is available.

The release tarballs are found at:

    http://code.google.com/p/git-core/downloads/list

and their SHA-1 checksums are:

382ee40da74a1b4a1875820c0f0a35c9ccd750f8  git-1.7.7.3.tar.gz
bc0f89cb04e562e4a6d3b936382dbc8f593d861f  git-htmldocs-1.7.7.3.tar.gz
cf1b0d35e2d242bc4cffce3b2bf5b3e32857b395  git-manpages-1.7.7.3.tar.gz

Also the following public repositories all have a copy of the v1.7.7.3
tag and the maint branch that the tag points at:

  url = git://repo.or.cz/alt-git.git
  url = https://code.google.com/p/git-core/
  url = git://git.sourceforge.jp/gitroot/git-core/git.git
  url = git://git-core.git.sourceforge.net/gitroot/git-core/git-core
  url = https://github.com/gitster/git

----------------------------------------------------------------

Changes since v1.7.7.2 are as follows:

Dan McGee (4):
      pack-objects: mark add_to_write_order() as inline
      pack-objects: use unsigned int for counter and offset values
      pack-objects: rewrite add_descendants_to_write_order() iteratively
      pack-objects: don't traverse objects unnecessarily

Jeff King (1):
      docs: don't mention --quiet or --exit-code in git-log(1)

Julien Muchembled (1):
      gitweb: fix regression when filtering out forks

Junio C Hamano (3):
      branch -m/-M: remove undocumented RENAMED-REF
      docs: Update install-doc-quick
      Git 1.7.7.3

