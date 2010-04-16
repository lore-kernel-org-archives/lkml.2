Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758217Ab0DPDSG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 23:18:06 -0400
Received: from josefsipek.net ([141.212.112.196]:60743 "EHLO josefsipek.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757608Ab0DPDSE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 23:18:04 -0400
X-Greylist: delayed 452 seconds by postgrey-1.27 at vger.kernel.org; Thu, 15 Apr 2010 23:18:04 EDT
Date: Thu, 15 Apr 2010 23:10:28 -0400
From: jeffpc@josefsipek.net
To: Git Mailing List <git@vger.kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: [ANNOUNCE] Guilt v0.33
Message-ID: <20100416031028.GV12152@josefsipek.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Guilt v0.33 is available for download (once it mirrors out on kernel.org).

Guilt (Git Quilt) is a series of bash scripts which add a Mercurial
queues-like functionality and interface to git.

Tarballs:
http://www.kernel.org/pub/linux/kernel/people/jsipek/guilt/

Git repo:
git://git.kernel.org/pub/scm/linux/kernel/git/jsipek/guilt.git


This release bundles up a bunch of the fixes that were released in the
various v0.32.x stable releases.  The major change is the addition of
support for git versions 1.7.x.

As always, patches, and other feedback is welcome.

Josef "Jeff" Sipek.

------------
Changes since v0.32:

Dmitry Monakhov (1):
      guilt: allow raw patch edit

Eric Sandeen (1):
      regression: filter usage() output

Josef 'Jeff' Sipek (10):
      regression: fix output mismatch with git 1.6.2
      select/guard: fixed bashism
      Guilt v0.32.1
      refresh: output the patch name similarly to what quilt does
      {fork,import}: check patchnames for colons
      regression: added a new test that exercises the guilt-import code
      {diff,import-commit,new}: fix handling of binary files
      regression: change two of the test patches to handle binary files
      header: use exit instead of return
      Guilt v0.33

Theodore Ts'o (1):
      guilt: Add support for git version 1.7.x.y

Vincent Penné (1):
      make guards functionning again

Yasushi SHOJI (1):
      allow guilt to handle binary files

-- 
Humans were created by water to transport it upward.
