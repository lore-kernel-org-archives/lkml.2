Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755262Ab1BHRac (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 12:30:32 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:51522 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755182Ab1BHRab (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 12:30:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:date:message-id:subject:from:to:cc
         :content-type;
        b=snr74Yf6A+Hgp37SCuJiXCm4NBbt3NMpuQ9OJA0tQetL/MwKAmp3Qr5niERddzS6lv
         HPpiB4AYrqkqv5NZmLRTOjhYSmbqDTFsdXe/hz6JWOUVhs1OnxXrmmXBJYL5UVGSbbFs
         3SMmGMUI6jlc9ae2PY/Uj4VCshyOZun1tOnXI=
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
Date: Tue, 8 Feb 2011 18:30:29 +0100
Message-ID: <AANLkTinXsDN4Bhp9_kcbeu6BNMADTSBVN_6+nn63w+kW@mail.gmail.com>
Subject: [ext4] Multiple page-io submission (Option "mblk_io_submit")
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: "Theodore Ts'o" <tytso@mit.edu>, Curt Wohlgemuth <curtw@google.com>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

while looking at pending patches in ext4.git#{master, for_linus}, I
saw "ext4: Fix data corruption with multi-block writepages support"
which should fix [2] according to text in the commit-body.

Are you planning to turn on "multiple page-io submission" again by
default (as is was disabled in "ext4: Turn off multiple page-io
submission by default" [3])?

Regards,
- Sedat -

[1] http://git.kernel.org/?p=linux/kernel/git/tytso/ext4.git;a=commit;h=d50bdd5aa55127635fd8a5c74bd2abb256bd34e3
[2] http://git.kernel.org/?p=linux/kernel/git/tytso/ext4.git;a=commit;h=bd2d0210cf22f2bd0cef72eb97cf94fc7d31d8cc
[3] http://git.kernel.org/?p=linux/kernel/git/tytso/ext4.git;a=commit;h=1449032be17abb69116dbc393f67ceb8bd034f92
