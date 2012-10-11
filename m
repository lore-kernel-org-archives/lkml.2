Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756261Ab2JKUKA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 16:10:00 -0400
Received: from b-pb-sasl-quonix.pobox.com ([208.72.237.35]:59811 "EHLO
	smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753395Ab2JKUJ7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 16:09:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=from:to:cc
	:subject:date:message-id:mime-version:content-type
	:content-transfer-encoding; q=dns; s=sasl; b=js9JCSsQZqpPq/6TMd0
	YHquzxc6pHZjMOHZQvx2IAJyRbPmPaSdVntLJYRmYfA9LBoPJbBgQ3dEdPpxKYxD
	nLn0ZLTZplvfpL/WneuBOfVXVTx0wMCB7vQgPSruKSDRPeDIjfNf/98nQDGZ38Dj
	mK+FGrimlTz/ChpjMhUBKFlc=
From: Junio C Hamano <gitster@pobox.com>
To: git@vger.kernel.org
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [ANNOUNCE] Git v1.8.0-rc2
Date: Thu, 11 Oct 2012 13:09:56 -0700
Message-ID: <7vy5jc6a97.fsf@alter.siamese.dyndns.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
X-Pobox-Relay-ID: A12BB0D8-13DF-11E2-B1A9-BB652E706CDE-77302942!b-pb-sasl-quonix.pobox.com
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A release candidate Git v1.8.0-rc2 is now available for testing
at the usual places.

The release tarballs are found at:

    http://code.google.com/p/git-core/downloads/list

and their SHA-1 checksums are:

6c8076b3bcf08ffc53a64bbfb0fa69f82096f711  git-1.8.0.rc2.tar.gz
86aca88717928d9d3a38c47a315d2c57402747ca  git-htmldocs-1.8.0.rc2.tar.gz
f4023824ee6b3ad561dba5dbdfe6e07532904a27  git-manpages-1.8.0.rc2.tar.gz

Also the following public repositories all have a copy of the v1.8.0-rc2
tag and the master branch that the tag points at:

  url = git://repo.or.cz/alt-git.git
  url = https://code.google.com/p/git-core/
  url = git://git.sourceforge.jp/gitroot/git-core/git.git
  url = git://git-core.git.sourceforge.net/gitroot/git-core/git-core
  url = https://github.com/gitster/git

Things seem to have calmed down and hopefully we can have the final
1.8.0 without regression soon.

----------------------------------------------------------------

Changes since v1.8.0-rc1 are as follows:

Ben Walton (1):
      tests: "cp -a" is a GNUism

Jonathan Nieder (2):
      git svn: work around SVN 1.7 mishandling of svn:special changes
      svn test: escape peg revision separator using empty peg rev

Junio C Hamano (2):
      gitcli: parse-options lets you omit tail of long options
      Git 1.8.0-rc2

Nguyễn Thái Ngọc Duy (2):
      gitignore.txt: suggestions how to get literal # or ! at the beginning
      attr: a note about the order of .gitattributes lookup

Ramkumar Ramachandra (1):
      Git url doc: mark ftp/ftps as read-only and deprecate them

Ramsay Allan Jones (1):
      MALLOC_CHECK: Allow checking to be disabled from config.mak

Simon Ruderich (1):
      l10n: de.po: fix a few minor typos

Øyvind A. Holm (1):
      configure.ac: Add missing comma to CC_LD_DYNPATH

