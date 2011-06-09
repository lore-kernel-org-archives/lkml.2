Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755058Ab1FIDOz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 23:14:55 -0400
Received: from a-pb-sasl-sd.pobox.com ([64.74.157.62]:34388 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751626Ab1FIDOv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 23:14:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=from:to:subject
	:cc:date:message-id:mime-version:content-type; q=dns; s=sasl; b=
	ZGxIZCMpxMcc1Jo8fubErMYpE59MbKyT6i0/KNpolERIhYj/WEg8bvAfPtM2fIwO
	r0Bti9mjxj8lxK4B6GHsDKu3Rxg9/i0J0mG1HzMybc+ulEjFzZete5jakgsA62g4
	BYs9dd0daHUH7H+WFhjDtyCORL27TN+BLxhG4OLz/H8=
From: Junio C Hamano <gitster@pobox.com>
To: git@vger.kernel.org
Subject: [ANNOUNCE] Git 1.7.6.rc1
cc: Linux Kernel <linux-kernel@vger.kernel.org>
Date: Wed, 08 Jun 2011 20:14:41 -0700
Message-ID: <7vlixbzof2.fsf@alter.siamese.dyndns.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Pobox-Relay-ID: EF476BCA-9246-11E0-A5E1-C8CFB7AE1C3C-77302942!a-pb-sasl-sd.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A release candidate Git 1.7.6-rc1 is available at the usual places
for testing:

  http://www.kernel.org/pub/software/scm/git/

  git-1.7.6.rc1.tar.{gz,bz2}			(source tarball)
  git-htmldocs-1.7.6.rc1.tar.{gz,bz2}		(preformatted docs)
  git-manpages-1.7.6.rc1.tar.{gz,bz2}		(preformatted docs)

The RPM binary packages for a few architectures are found in:

  testing/git-*-1.7.6.rc1-1.fc13.$arch.rpm	(RPM)

A week has passed since the casual "-rc0" was tagged, so here is the first
official release candidate, with RPM and announcement.

Please switch to the tip of 'master' for your daily use so that we can
ship 1.7.6 without regressions and bugs in new features in two weeks.

Thanks.

----------------------------------------------------------------

Changes since v1.7.6-rc0 are as follows:

Alex Riesen (1):
      t3703: skip more tests using colons in file names on Windows

Brandon Casey (2):
      t7508: demonstrate status's failure to use --porcelain format with -z
      builtin/commit.c: set status_format _after_ option parsing

Jakub Narebski (4):
      gitweb: Move information about installation from README to INSTALL
      gitweb: Describe CSSMIN and JSMIN in gitweb/INSTALL
      gitweb: Move "Requirements" up in gitweb/INSTALL
      gitweb: Fix usability of $prevent_xss

Jeff King (1):
      diff_tree: disable QUICK optimization with diff filter

Jim Meyering (1):
      fetch: do not leak a refspec

Junio C Hamano (2):
      diff: futureproof "stop feeding the backend early" logic
      Git 1.7.6-rc1

