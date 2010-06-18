Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760979Ab0FRLI5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 07:08:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18523 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760956Ab0FRLIz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 07:08:55 -0400
Date: Fri, 18 Jun 2010 13:08:52 +0200
From: Karel Zak <kzak@redhat.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       util-linux-ng@vger.kernel.org
Subject: [ANNOUNCE] util-linux-ng v2.18-rc2
Message-ID: <20100618110852.GJ2200@nb.net.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The second util-linux-ng 2.18 release candidate is available at

   ftp://ftp.kernel.org/pub/linux/utils/util-linux-ng/v2.18/

Feedback and bug reports, as always, are welcomed.

	Karel


Changes between v2.18-rc1 and v2.18-rc2
---------------------------------------

cal:
   - remove unnecessary info from man page  [Karel Zak]
chrt:
   - add --verbose to man page, correct -V for --version, alphabetize  [Benno Schulenberg]
   - change two messages into four translatable sentences  [Benno Schulenberg]
   - slice help text into manageable chunks for translators  [Benno Schulenberg]
docs:
   - fix umount --fake note in ReleaseNotes  [Karel Zak]
   - update v2.18 ReleaseNotes  [Karel Zak]
fdisk:
   - disable DOS mode and cylinders by default  [Karel Zak]
   - extend -c and -u options to support old DOS stuff  [Karel Zak]
   - remove erroneous <size> argument from -u option in help text  [Benno Schulenberg]
   - untangle the reporting of deprecated mode and unit  [Benno Schulenberg]
findmnt:
   - ungettextize the directions and fix spelling  [Benno Schulenberg]
lscpu:
   - add CPU_EQUAL_S definition for old/obscure libc  [Karel Zak]
   - fix CPU_EQUAL_S macro  [Karel Zak]
   - fix typo, "faild" to "failed"  [Benno Schulenberg]
messages:
   - gettextize a few skipped or forgotten ones  [Benno Schulenberg]
mkswap:
   - add a note that -p is uncecessary  [Karel Zak]
   - don't use too small user-specified page size  [Karel Zak]
   - use calloc(), remove obsolete v1 header usage  [Karel Zak]
mount:
   - add notes about -o remount,ro,bind to mount.8  [Karel Zak]
   - don't create loopdev for MS_BIND  [Karel Zak]
   - use %u for uid_t and gid_t  [Karel Zak]
po:
   - merge changes  [Karel Zak]
   - update cs.po (from translationproject.org)  [Petr Pisar]
   - update nl.po (from translationproject.org)  [Benno Schulenberg]
   - update pl.po (from translationproject.org)  [Jakub Bogusz]
tests:
   - update fdisk tests  [Karel Zak]
textual:
   - fix typos  [Karel Zak]
   - fix typos, and rephrase some things for clarity  [Benno Schulenberg]
uuidd:
   - spell the plural of "UUID" consistently as "UUIDs"  [Benno Schulenberg]
wipefs:
   - fix mem usage  [Karel Zak]
   - fix memory leaks  [Karel Zak]


Release Notes:
  ftp://ftp.kernel.org/pub/linux/utils/util-linux-ng/v2.18/v2.18-ReleaseNotes

Detailed ChangeLog:
  ftp://ftp.kernel.org/pub/linux/utils/util-linux-ng/v2.18/v2.18-rc2-ChangeLog

-- 
 Karel Zak  <kzak@redhat.com>
 http://karelzak.blogspot.com
