Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757332Ab1KRWiK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 17:38:10 -0500
Received: from b-pb-sasl-quonix.pobox.com ([208.72.237.35]:37638 "EHLO
	smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756209Ab1KRWiG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 17:38:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=from:to:subject
	:cc:date:message-id:mime-version:content-type
	:content-transfer-encoding; q=dns; s=sasl; b=bcHcOVsA6E1I63qtqD/
	VcogAj4SB5ejxKinIc7/O4lRy+hMKbdqvkLk4HQE/1cGkVsIlT8hMxfPsuhJe/Gl
	HUnoyH0Y5wlzRmFALjhYkdDi7uz46VAWJShTaX5nNxexGuw07X4LAmZJMw3+CjKJ
	tvlrm7ShdSCnRJ/Hpc6N827o=
From: Junio C Hamano <gitster@pobox.com>
To: git@vger.kernel.org
Subject: [ANNOUNCE] Git 1.7.7.4
cc: Linux Kernel <linux-kernel@vger.kernel.org>
Date: Fri, 18 Nov 2011 14:38:03 -0800
Message-ID: <7vbos9jbuc.fsf@alter.siamese.dyndns.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
X-Pobox-Relay-ID: FB07F62C-1235-11E1-B9A1-9DB42E706CDE-77302942!b-pb-sasl-quonix.pobox.com
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The latest maintenance release Git 1.7.7.4 is available.

The release tarballs are found at:

    http://code.google.com/p/git-core/downloads/list

and their SHA-1 checksums are:

5b6920989480a37ec65977e756b24961578795dd  git-1.7.7.4.tar.gz
6012cb017a04ded85c48ca5510f741e98c02f671  git-htmldocs-1.7.7.4.tar.gz
cb21e55ae793865453c165a0e666348f2db8c740  git-manpages-1.7.7.4.tar.gz

Also the following public repositories all have a copy of the v1.7.7.4
tag and the maint branch that the tag points at:

  url = git://repo.or.cz/alt-git.git
  url = https://code.google.com/p/git-core/
  url = git://git.sourceforge.jp/gitroot/git-core/git.git
  url = git://git-core.git.sourceforge.net/gitroot/git-core/git-core
  url = https://github.com/gitster/git


Git v1.7.7.4 Release Notes
==========================

Fixes since v1.7.7.3
--------------------

 * A few header dependencies were missing from the Makefile.

 * Some newer parts of the code used C99 __VA_ARGS__ while we still
   try to cater to older compilers.

 * "git name-rev --all" tried to name all _objects_, naturally failing to
   describe many blobs and trees, instead of showing only commits as
   advertised in its documentation.

----------------------------------------------------------------

Changes since v1.7.7.3 are as follows:

Jonathan Nieder (2):
      notes merge: eliminate OUTPUT macro
      Makefile: add missing header file dependencies

Junio C Hamano (2):
      name-rev --all: do not even attempt to describe non-commit object
      Git 1.7.7.4

Marc-André Lureau (1):
      mailmap: xcalloc mailmap_info

