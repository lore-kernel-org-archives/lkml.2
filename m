Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751349Ab1GYMIR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 08:08:17 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:50908 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750864Ab1GYMII (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 08:08:08 -0400
MIME-Version: 1.0
Date: Mon, 25 Jul 2011 13:08:06 +0100
X-Google-Sender-Auth: ek92e-DJTgipWWF5YWDNAVI8pAI
Message-ID: <CAPweEDzv+vByC1s2bWRjVQdVLqw4Xf2sUf_CQgVync_YcxtdvQ@mail.gmail.com>
Subject: ext3 hacked filesystem (by debian exim4 exploit) available for
 analysis and bugreporting
From: Luke Kenneth Casson Leighton <lkcl@lkcl.net>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

folks, hi,

i appreciate this was some time ago, but i encountered a quite serious
issue with an ext3 filesystem that had been hacked, and a rootkit
installed.  this was with a 2.6.26 kernel.  the issue encountered was
that the little fuckers directly modified the ext3 filesystem so that
some files they had created could *not* be deleted.  when i say "could
not be deleted" i mean "absolutely could not be deleted".  also, fsck
did *not* report any "problems".

and yes, please do give me credit for knowing that you should use a
different system (offline) to analyse the [damaged] filesystem :)  as
you can imagine, i was very very surprised to encounter this as an
issue.

first thing: has anyone else encountered this?

second thing: if answer "no" to above, would anyone who can prove
their credentials (public ssh key, public web site, notability blah
blah) like to analyse the 5gb filesystem?  i still have a copy (it's
an LVM2 partition on a Xen hosted server).

apart from anything, this really really should go into rkhunter /
chkrootkit, but it requires someone with expertise to actually analyse
what the bloody hell happened.  apart from anything, files which
cannot be deleted (and cannot be detected as "corrupted" by fsck.ext3)
is pretty damn serious.

l.
