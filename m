Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757475Ab0DXBYc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 21:24:32 -0400
Received: from a-pb-sasl-quonix.pobox.com ([208.72.237.25]:58229 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751644Ab0DXBY2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 21:24:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=to:subject:from
	:date:message-id:mime-version:content-type
	:content-transfer-encoding; q=dns; s=sasl; b=QbTKryZGTIh8hUuT2XS
	YRpcYHT8zfx7m60npgYZ9yL+ny4eD8gcy4EHuStCHzgpx/+qObdVwstRArlZOueu
	IQXg3pcTmJxZV3muW9qYrA4ts2bYo+1vL3Ru6KAbOua4+JQDAKzyrAngEb5LlQb4
	IYMB7kX2wcSnwp3ck6buXsSc=
To: git@vger.kernel.org
Subject: [ANNOUNCE] Git 1.7.0.6
From: Junio C Hamano <gitster@pobox.com>
Date: Fri, 23 Apr 2010 18:24:18 -0700
Message-ID: <7v4oj1ve0t.fsf@alter.siamese.dyndns.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
X-Pobox-Relay-ID: 1D5E118A-4F40-11DF-9F1B-D033EE7EF46B-77302942!a-pb-sasl-quonix.pobox.com
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 Git 1.7.0.6 is available at the usual places:

  http://www.kernel.org/pub/software/scm/git/

  git-1.7.0.6.tar.{gz,bz2}			(source tarball)
  git-htmldocs-1.7.0.6.tar.{gz,bz2}		(preformatted docs)
  git-manpages-1.7.0.6.tar.{gz,bz2}		(preformatted docs)

The RPM binary packages for a few architectures are found in:

  RPMS/$arch/git-*-1.7.0.6-1.fc11.$arch.rpm	(RPM)

----------------------------------------------------------------

Git v1.7.0.6 Release Notes
==========================

Fixes since v1.7.0.5
--------------------

 * "git diff --stat" used "int" to count the size of differences,
   which could result in overflowing.

 * "git rev-list --abbrev-commit" defaulted to 40-byte abbreviations, unlike
   newer tools in the git toolset.

And other minor fixes and documentation updates.

----------------------------------------------------------------

Changes since v1.7.0.5 are as follows:

Charles Bailey (1):
      Documentation: Describe other situations where -z affects git diff

David Aguilar (1):
      Makefile: Remove usage of deprecated Python "has_key" method

Jay Soffian (1):
      Documentation/config.txt: default gc.aggressiveWindow is 250, not 10

Jeff King (1):
      diff: use large integers for diffstat calculations

Johannes Sixt (1):
      MSVC: Fix build by adding missing termios.h dummy

Jonathan Nieder (2):
      Document new "already-merged" rule for branch -d
      Documentation/Makefile: fix interrupted builds of user-manual.xml

Junio C Hamano (1):
      Git 1.7.0.6

Marc Branchaud (1):
      Docs: Add -X option to git-merge's synopsis.

Michael J Gruber (3):
      rev-list: use default abbrev length when abbrev-commit is in effect
      t1010-mktree: Adjust expected result to code and documentation
      t7012: Mark missing tests as TODO

SZEDER Gábor (1):
      reflog: remove 'show' from 'expire's usage string

Thomas Rast (1):
      combined diff: correctly handle truncated file

Will Palmer (1):
      documentation: clarify direction of core.autocrlf

