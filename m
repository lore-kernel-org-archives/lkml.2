Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757873Ab1BLAxd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 19:53:33 -0500
Received: from a-pb-sasl-sd.pobox.com ([64.74.157.62]:36133 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757088Ab1BLAxb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 19:53:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=to:subject:from
	:date:message-id:mime-version:content-type
	:content-transfer-encoding; q=dns; s=sasl; b=XNfas63X5WeBgcZMiC+
	XnZZphW5Pm+g+hieFYNSRZplOmmenurYe9lvmoESTYNw97204nIgAZ7FfwZ3sCTS
	0GMWB/OxjqbaUF8s1Iw6QKzemVOeL91rXLwBpMUdmN5jBTNbVJ/iyT3kF4lcbW6o
	J7Hx2+zOW2T72kgUXLKtaNrY=
To: git@vger.kernel.org
Subject: [ANNOUNCE] Git 1.7.4.1
From: Junio C Hamano <gitster@pobox.com>
Date: Fri, 11 Feb 2011 16:53:20 -0800
Message-ID: <7vei7eysxr.fsf@alter.siamese.dyndns.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
X-Pobox-Relay-ID: A4A986A8-3642-11E0-97E3-AF401E47CF6F-77302942!a-pb-sasl-sd.pobox.com
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The first maintenance release Git 1.7.4.1 is available at the usual
places:

  http://www.kernel.org/pub/software/scm/git/

  git-1.7.4.1.tar.{gz,bz2}			(source tarball)
  git-htmldocs-1.7.4.1.tar.{gz,bz2}		(preformatted docs)
  git-manpages-1.7.4.1.tar.{gz,bz2}		(preformatted docs)

The RPM binary packages for a few architectures are found in:

  RPMS/$arch/git-*-1.7.4.1-1.fc13.$arch.rpm	(RPM)


Git v1.7.4.1 Release Notes
==========================

Fixes since v1.7.4
------------------

 * On Windows platform, the codepath to spawn a new child process forgot
   to first flush the output buffer.

 * "git bundle" did not use OFS_DELTA encoding, making its output a few
   per-cent larger than necessarily.

 * The option to tell "git clone" to recurse into the submodules was
   misspelled with an underscore "--recurse_submodules".

 * "git diff --cached HEAD" before the first commit does what an end user
   would expect (namely, show what would be committed without further "git
   add").

 * "git fast-import" didn't accept the command to ask for "notes" feature
   to be present in its input stream, even though it was capable of the
   feature.

 * "git fsck" gave up scanning loose object files in directories with
   garbage files.

And other minor fixes and documentation updates.

----------------------------------------------------------------

Changes since v1.7.4 are as follows:

Chris Packham (1):
      clone: fixup recurse_submodules option

Jakub Narebski (1):
      gitweb: Mention optional Perl modules in INSTALL

Jens Lehmann (2):
      t5526: Fix wrong argument order in "git config"
      pull: Document the "--[no-]recurse-submodules" options

Johannes Sixt (2):
      start_command: flush buffers in the WIN32 code path as well
      t4120-apply-popt: help systems with core.filemode=false

Jonathan Nieder (5):
      quote.h: simplify the inclusion
      fast-import: clarify documentation of "feature" command
      fast-import: introduce "feature notes" command
      compat: helper for detecting unsigned overflow
      svn-fe: warn about experimental status

Junio C Hamano (3):
      fsck: drop unused parameter from traverse_one_object()
      fsck: do not give up too early in fsck_dir()
      Git 1.7.4.1

Nguyễn Thái Ngọc Duy (4):
      diff: support --cached on unborn branches
      Add const to parse_{commit,tag}_buffer()
      sha1_file.c: move find_cached_object up so sha1_object_info can use it
      sha1_object_info: examine cached_object store too

Pat Thoyts (2):
      t3509: use unconstrained initial test to setup repository.
      t7407: fix line endings for mingw build

Shawn O. Pearce (1):
      bundle: Use OFS_DELTA in bundle files

Sitaram Chamarty (1):
      post-receive-email: suppress error if description file missing

Uwe Kleine-König (1):
      Documentation/merge subtree How-To: fix typo

