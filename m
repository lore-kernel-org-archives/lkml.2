Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757904Ab2FUWQA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 18:16:00 -0400
Received: from b-pb-sasl-quonix.pobox.com ([208.72.237.35]:46428 "EHLO
	smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754897Ab2FUWP7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 18:15:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=from:to:cc
	:subject:date:message-id:mime-version:content-type; q=dns; s=
	sasl; b=Gn3qAxT3sb1+M+RwGzifQjZ+/fxNTXNTKwtzCFDfsWP6Yoo5Cr9+aitO
	XCisKA7FdB83aYYC3p+7kHqfUqfzhjce0f9gAQO/EV/nBZbaEzr4A9FiiKE8P3FW
	NngTOX1H7v5077uo8TyZj7V98XH7K5hQOvXc9Rb3A7iTO8kVw/o=
From: Junio C Hamano <gitster@pobox.com>
To: git@vger.kernel.org
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [ANNOUNCE] Git v1.7.11.1
Date: Thu, 21 Jun 2012 15:15:56 -0700
Message-ID: <7vpq8sqpk3.fsf@alter.siamese.dyndns.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Pobox-Relay-ID: AD237F0E-BBEE-11E1-AA9F-FC762E706CDE-77302942!b-pb-sasl-quonix.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The latest maintenance release Git v1.7.11.1 is now available at
the usual places.

It is a bit embarrassing but it turns out that all cross links in
the HTML version of manual pages in Git 1.7.11 were missing, and
that is the primary reason for this one.

The release tarballs are found at:

    http://code.google.com/p/git-core/downloads/list

and their SHA-1 checksums are:

d09664978931d215e43241689eb09371b509c7ce  git-1.7.11.1.tar.gz
f7d288033a508f673824a52bc21073232e7c9736  git-htmldocs-1.7.11.1.tar.gz
e2defbf75ff15d7684d70457e41bc45fb22f0e1f  git-manpages-1.7.11.1.tar.gz

Also the following public repositories all have a copy of the v1.7.11.1
tag and the maint branch that the tag points at:

  url = git://repo.or.cz/alt-git.git
  url = https://code.google.com/p/git-core/
  url = git://git.sourceforge.jp/gitroot/git-core/git.git
  url = git://git-core.git.sourceforge.net/gitroot/git-core/git-core
  url = https://github.com/gitster/git

Git v1.7.11.1 Release Notes
===========================

Fixes since v1.7.11
-------------------

 * The cross links in the HTML version of manual pages were broken.

Also contains minor typofixes and documentation updates.

----------------------------------------------------------------

Changes since v1.7.11 are as follows:

Jeff King (1):
      docs: always define git-relative-html-prefix attribute

Junio C Hamano (2):
      git-commit-tree(1): update synopsis
      Git 1.7.11.1

Miklos Vajna (1):
      Documentation: spelling fixes

