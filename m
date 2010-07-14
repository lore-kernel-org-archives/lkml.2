Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757050Ab0GNXOt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 19:14:49 -0400
Received: from a-pb-sasl-quonix.pobox.com ([208.72.237.25]:58879 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751786Ab0GNXOs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 19:14:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=to:subject:from
	:date:message-id:mime-version:content-type
	:content-transfer-encoding; q=dns; s=sasl; b=YhpBpw6Q0I8tYRRtW3H
	n41ysizWNICXREXRn+/UvV66Lkfk3ccmPbW4Q5TJSzKvIKHYLO+sd6gZ2/h805H5
	minfYltnol2/RJoR0v2n1BHnrDp9B5L0IzWEdye9CmpF7u8DSYJwPlY2UB2MBjNF
	aMse1Ud/fY0j4elv8xTKgO5I=
To: git@vger.kernel.org
Subject: [ANNOUNCE] Git 1.7.2.rc3
From: Junio C Hamano <gitster@pobox.com>
Date: Wed, 14 Jul 2010 16:14:37 -0700
Message-ID: <7vmxttwt9e.fsf@alter.siamese.dyndns.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
X-Pobox-Relay-ID: 956EE828-8F9D-11DF-A8F5-9056EE7EF46B-77302942!a-pb-sasl-quonix.pobox.com
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A release candidate Git 1.7.2.rc3 is available at the usual places
for testing:

  http://www.kernel.org/pub/software/scm/git/

  git-1.7.2.rc3.tar.{gz,bz2}			(source tarball)
  git-htmldocs-1.7.2.rc3.tar.{gz,bz2}		(preformatted docs)
  git-manpages-1.7.2.rc3.tar.{gz,bz2}		(preformatted docs)

The RPM binary packages for a few architectures are found in:

  testing/git-*-1.7.2.rc3-1.fc11.$arch.rpm	(RPM)

Hopefully this will be the last one before the final I'd like to have by
the end of the week.

----------------------------------------------------------------

Changes since v1.7.2-rc2 are as follows:

Bo Yang (1):
      diff.c: fix a graph output bug

Fredrik Skolmli (1):
      Documentation: Spelling fix in protocol-capabilities.txt

Johannes Sixt (1):
      t0005: work around strange $? in ksh when program terminated by a signal

Jonathan Nieder (1):
      t9118 (git-svn): prevent early failure from taking down later tests

Junio C Hamano (2):
      Fix "read-tree -m A B" priming the cache-tree
      Git 1.7.2-rc3

Michael J Gruber (3):
      t9118: avoid PEG revision identifier in tests
      test-lib: simplify GIT_SKIP_TESTS loop
      test-lib: TAP compliance for skipping tests on request

Miklos Vajna (1):
      format-patch: document the format.to configuration setting

Nicolas Sebrecht (1):
      checkout: accord documentation to what git does

Oren Held (1):
      git fetch documentation: describe short '-p' synonym to '--prune' option

Raja R Harinath (1):
      Use dev_t for device id (st_dev) from stat in setup_git_directory_gently()

Ævar Arnfjörð Bjarmason (1):
      tests: Use skip_all=* to skip tests

