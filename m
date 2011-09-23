Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753189Ab1IWXls (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 19:41:48 -0400
Received: from b-pb-sasl-quonix.pobox.com ([208.72.237.35]:45718 "EHLO
	smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751900Ab1IWXlr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 19:41:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=from:to:subject
	:cc:date:message-id:mime-version:content-type; q=dns; s=sasl; b=
	LIOuGEAeImvVeTxEBqm8SO2fXUJhJuX78g1r1WIVI7CVRyw7rC1/vHW1KtAlgLOf
	nltFR20qkycoZvvsxaKB7qtSjPxvBPH3Q9NPg4OwDpmlN91Tqu6lf9lrf4FO3hu/
	4GNvWKcYRuSzfHIKlix5pmOqy+GdDjYjr5JO89uk0wA=
From: Junio C Hamano <gitster@pobox.com>
To: git@vger.kernel.org
Subject: [ANNOUNCE] Git 1.7.7.rc3
cc: Linux Kernel <linux-kernel@vger.kernel.org>
Date: Fri, 23 Sep 2011 16:41:44 -0700
Message-ID: <7vhb42su6f.fsf@alter.siamese.dyndns.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Pobox-Relay-ID: 99768EC4-E63D-11E0-9D0F-9DB42E706CDE-77302942!b-pb-sasl-quonix.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A release candidate Git 1.7.7.rc3 is available for testing but not at the
usual places.

The tarball is found at:

    http://code.google.com/p/git-core/downloads/list

and its SHA-1 checksum is:

c6ba05a833cab49dd66dd1e252306e187effbf2b  git-1.7.7.rc3.tar.gz

Also the following public repositories all have a copy of the v1.7.7-rc3
tag and the master branch that the tag points at:

        url = git://repo.or.cz/alt-git.git
        url = https://code.google.com/p/git-core/
        url = git://git.sourceforge.jp/gitroot/git-core/git.git
        url = git://git-core.git.sourceforge.net/gitroot/git-core/git-core
        url = https://github.com/gitster/git

I had to make a quick fix for a recent regression directly on master, and
I would like to cook it for a few days, so the final has to wait til mid
next week.

Until then please help testing to find other regressions.

----------------------------------------------------------------

Changes since v1.7.7-rc2 are as follows:

Allan Caffee (1):
      describe: Refresh the index when run with --dirty

Jay Soffian (1):
      git-mergetool: check return value from read

Jeff King (1):
      t4014: clean up format.thread config after each test

Junio C Hamano (3):
      Git 1.7.6.4
      merge-recursive: Do not look at working tree during a virtual ancestor merge
      Git 1.7.7-rc3

