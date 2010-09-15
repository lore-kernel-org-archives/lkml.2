Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755246Ab0IOWUc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 18:20:32 -0400
Received: from a-pb-sasl-quonix.pobox.com ([208.72.237.25]:54708 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752062Ab0IOWUa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 18:20:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=to:subject:from
	:date:message-id:mime-version:content-type
	:content-transfer-encoding; q=dns; s=sasl; b=JowqcuBuAnYd+l9oaUW
	OSpCAP4cmq5FcdoRydr1ZPI+3R8iJ5HTG1dDSw3pndrgMWMqJkeMXmZCXRQ5iGS0
	eZcZPLYUR/tmrsErNBJ878n8i4AbUhM92NREtddgeKblEY0re1FvR5+DDFRpM9hP
	1696LZdDnvC8VV6wy76u4Ixc=
To: git@vger.kernel.org
Subject: [ANNOUNCE] Git 1.7.3.rc2
From: Junio C Hamano <gitster@pobox.com>
Date: Wed, 15 Sep 2010 15:20:21 -0700
Message-ID: <7vd3se644a.fsf@alter.siamese.dyndns.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
X-Pobox-Relay-ID: 70F4868C-C117-11DF-B94D-030CEE7EF46B-77302942!a-pb-sasl-quonix.pobox.com
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A release candidate Git 1.7.3.rc2 is available at the usual places
for testing:

  http://www.kernel.org/pub/software/scm/git/

  git-1.7.3.rc2.tar.{gz,bz2}			(source tarball)
  git-htmldocs-1.7.3.rc2.tar.{gz,bz2}		(preformatted docs)
  git-manpages-1.7.3.rc2.tar.{gz,bz2}		(preformatted docs)

The RPM binary packages for a few architectures are found in:

  testing/git-*-1.7.3.rc2-1.fc11.$arch.rpm	(RPM)



Changes since v1.7.3-rc1 are as follows:

Csaba Henk (2):
      bundle: detect if bundle file cannot be created
      filter-branch: retire --remap-to-ancestor

Jens Lehmann (2):
      Several tests: cd inside subshell instead of around
      t1020: Get rid of 'cd "$HERE"' at the start of each test

Jonathan Nieder (5):
      tests: subshell indentation stylefix
      t1450 (fsck): remove dangling objects
      t2105 (gitfile): add missing &&
      t1302 (core.repositoryversion): style tweaks
      t2016 (checkout -p): add missing &&

Junio C Hamano (3):
      t3101: modernise style
      ls-tree $di $dir: do not mistakenly recurse into directories
      Git 1.7.3 rc2

Matthieu Moy (1):
      git-gui: use shell to launch textconv filter in "blame"

Oded Shimon (1):
      Add --src/dst-prefix to git-formt-patch in git-rebase.sh

Pat Thoyts (6):
      git-gui: Make usage statement visible on Windows.
      git-gui: display error launching blame as a message box.
      git-gui: handle textconv filter on Windows and in development
      git-gui: ensure correct application termination in git-gui--askpass
      git-gui: avoid mis-encoding the copyright message on Windows.
      git-gui 0.13

Peter Krefting (1):
      git-gui: Update Swedish translation (521t).

Ramsay Allan Jones (1):
      vcs-svn: Fix some printf format compiler warnings

René Scharfe (1):
      compat/nedmalloc: don't force NDEBUG on the rest of git

Schalk, Ken (1):
      Avoid rename/add conflict when contents are identical
