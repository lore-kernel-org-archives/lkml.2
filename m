Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755327Ab2EYLSZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 07:18:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41132 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751923Ab2EYLSX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 07:18:23 -0400
Date: Fri, 25 May 2012 13:18:21 +0200
From: Karel Zak <kzak@redhat.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        util-linux@vger.kernel.org
Subject: [ANNOUNCE] util-linux v2.21.2
Message-ID: <20120525111821.GC3781@x2.net.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2011-07-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The util-linux stable release 2.21.2 is available at

   ftp://ftp.kernel.org/pub/linux/utils/util-linux/v2.21

Feedback and bug reports, as always, are welcomed.

    Karel



util-linux 2.21.2 Release Notes
===============================

Changes since v2.21.1
---------------------

 For more details see ChangeLog files at:
 ftp://ftp.infradead.org/pub/util-linux/v2.21/


cal:
   - Fix building under uClibc.  [James Le Cuirot]
docs:
   - update AUTHORS file  [Karel Zak]
findmnt:
   - fallback to mountinfo for polling  [Dave Reisner]
   - reference correct manual section  [Dave Reisner]
include:
   - [c.h] protect container_of  [maximilian attems]
lib/loopdev:
   - more robust initialization  [Karel Zak]
libblkid:
   - accept small blocks for NTFS and Reiserfs in blkid  [Vladimir 'φ-coder/phcoder' Serbinenko]
   - befs  declare functions static  [Petr Uzel]
   - support UFS UUID  [Vladimir 'φ-coder/phcoder' Serbinenko]
libmount:
   - backport mnt_context_guess_fstype() changes  [Karel Zak]
   - close device fd (to avoid mount(2) EBUSY)  [Karel Zak]
   - don't canonicalize target  [Karel Zak]
   - fix mnt_context_guess_fstype()  [Karel Zak]
   - fix mount by pattern  [Karel Zak]
   - use stderr for initial debug message  [Karel Zak]
libuuid:
   - fix typo in uuid_compare manpage  [Petr Uzel]
logger:
   - remove use of __P  [Jeremy Huntwork]
login:
   - add USER to initial environment  [Dave Reisner]
   - fix segmentation fault in log_utmp  [Karel Zak]
   - use getdtablesize() correctly in login.c  [chas williams - CONTRACTOR]
lsblk:
   - fix /sys/.../ro usage  [Karel Zak]
   - improve man page wording  [Regid Ichira]
lscpu:
   - fix possibly undefined operation  [Petr Uzel]
misc-utils:
   - cleanup unused strings.h includes  [maximilian attems]
mount:
   - fix man page typo s/reatime/relatime/  [Karel Zak]
namei:
   - fix relative symlinks evaluation  [Karel Zak]
po:
   - merge changes  [Karel Zak]
   - update de.po (from translationproject.org)  [Arun Persaud]
   - update vi.po (from translationproject.org)  [Trần Ngọc Quân]
   - update zh_CN.po (from translationproject.org)  [Wylmer Wang]
rev:
   - mention tac(1) in 'SEE ALSO' man page section  [James R. Van Zandt]
rtcwake:
   - only invoke RTC_AIE_ON/OFF ioctls in pairs  [Paul Fox]
setterm:
   - correct manual page reference  [Sami Kerola]
sfdisk:
   - fix calculation due to type mismatch (ix86)  [Petr Uzel]
tests:
   - add UFS uuids to results  [Karel Zak]
tools:
   - improve ko-release-* scripts  [Karel Zak]

