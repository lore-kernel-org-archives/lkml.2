Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752608Ab1AXWg3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 17:36:29 -0500
Received: from a-pb-sasl-sd.pobox.com ([64.74.157.62]:58756 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751527Ab1AXWg2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 17:36:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=to:subject:from
	:date:message-id:mime-version:content-type
	:content-transfer-encoding; q=dns; s=sasl; b=SuKXkvlrbQu2XYGiCBy
	Ltx4L3lVlFIuZ9dJwf4Q0yh0DS+ywurZtlql0WDHxRZ0iheB2vI71Ujr4b/3Lsem
	oUkNqCeng7VokuNXDocNwz/EWnSrluUBOUV8Yir5Gg/VXaqjrv0fXjEZnBYLDlyA
	GJ50BLI7XKJBEz7yViNxsgNM=
To: git@vger.kernel.org
Subject: [ANNOUNCE] Git 1.7.4-rc3
From: Junio C Hamano <gitster@pobox.com>
Date: Mon, 24 Jan 2011 14:36:16 -0800
Message-ID: <7vzkqqkjz3.fsf@alter.siamese.dyndns.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
X-Pobox-Relay-ID: 7C5F7DE2-280A-11E0-822C-BC4EF3E828EC-77302942!a-pb-sasl-sd.pobox.com
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A release candidate Git 1.7.4-rc3 is available at the usual places
for testing:

  http://www.kernel.org/pub/software/scm/git/

  git-1.7.4.rc3.tar.{gz,bz2}			(source tarball)
  git-htmldocs-1.7.4.rc3.tar.{gz,bz2}		(preformatted docs)
  git-manpages-1.7.4.rc3.tar.{gz,bz2}		(preformatted docs)

The RPM binary packages for a few architectures are found in:

  testing/git-*-1.7.4.rc3-1.fc13.$arch.rpm	(RPM)

Except for a regression fix to keep honoring "git --work-tree=/there/ cmd"
without specifying --git-dir (Thanks Jonathan), there isn't any exciting
new thing to see here; which is exactly the way how I want an rc3 to be.

Hopefully we can tag the final by the end of the month.  Everybody, thanks
in advance for testing this rc ;-).

----------------------------------------------------------------

Changes since v1.7.4-rc2 are as follows:

Alexey Shumkin (1):
      userdiff: match Pascal class methods

Björn Steinbrink (1):
      Correctly report corrupted objects

Erik Faye-Lund (1):
      exec_cmd: remove unused extern

Johannes Sixt (2):
      Fix expected values of setup tests on Windows
      t/README: hint about using $(pwd) rather than $PWD in tests

Jonathan Nieder (9):
      ll-merge: simplify opts == NULL case
      Documentation/fast-import: capitalize beginning of sentence
      remote-ext: do not segfault for blank lines
      Documentation/fast-import: put explanation of M 040000 <dataref> "" in context
      tests: cosmetic improvements to the repo-setup test
      tests: compress the setup tests
      Documentation: do not treat reset --keep as a special case
      Subject: setup: officially support --work-tree without --git-dir
      t1510: fix typo in the comment of a test

Junio C Hamano (2):
      Documentation updates for 'GIT_WORK_TREE without GIT_DIR' historical usecase
      Git 1.7.4-rc3

Ramsay Allan Jones (1):
      svndump.c: Fix a printf format compiler warning

