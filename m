Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932383Ab1J1LVK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 07:21:10 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:50384 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932325Ab1J1LVH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 07:21:07 -0400
From: "Justin Piszcz" <jpiszcz@lucidpixels.com>
To: <vnc-list@realvnc.com>, <linux-kernel@vger.kernel.org>
Cc: <ola@inguza.com>, <ap@solarrain.com>
Subject: RE: 3.x/libc6 -- out of ideas -- launching chrome results in an immediate crash of Xvnc everytime [SOLVED, well root cause found anyway]
Date: Fri, 28 Oct 2011 07:20:55 -0400
Message-ID: <00d201cc9563$a94739a0$fbd5ace0$@lucidpixels.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
thread-index: AcyVYHLbOwKSsO10Rdu5FeUrfpEMpg==
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

It came down to this Google Chrome extension:

Name: Extensions Manager (aka switcher)
Version: 0.1.6.95_0

When this extension is enabled in 64-bit Linux when I launch Google Chrome
on two separate machines (both 64-bit/Debian), it crashes Xvnc, when I
disable/remove this extension, Xvnc no longer crashes (at least it has not
yet :-))

All of this hassle due to 1 bad plug-in; in any event though there is a bug
in X/VNC, an application should not crash VNC.

Just a heads up to anyone else who sees this problem.

Justin.

