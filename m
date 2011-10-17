Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751733Ab1JQR7z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 13:59:55 -0400
Received: from mx3.schottelius.org ([77.109.138.221]:40953 "EHLO
	mx3.schottelius.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751633Ab1JQR7x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 13:59:53 -0400
Date: Mon, 17 Oct 2011 19:59:06 +0200
From: Nico Schottelius <nico-linux-20111017@schottelius.org>
To: LKML <linux-kernel@vger.kernel.org>
Subject: Keyboard and mouse issues on MacBook Air (4,2)
Message-ID: <20111017175906.GA3461@schottelius.org>
Mail-Followup-To: Nico Schottelius <nico-linux-20111017@schottelius.org>,
	LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: echo $message | gpg -e $sender  -s | netcat mailhost 25
X-Netzseite: http://www.nico.schottelius.org/
X-System-Info: brief (Linux 3.0-ARCH x86_64)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello LKML,

after several days of reading various forums and mailinglists,
it seems that keyboard and mouse support on the MacBook Air is
pretty broken:

- The fn key does not modify the cursor behaviour:
  FN+Cursor up should result in Page up,
  FN+Cursor down should result in Page down, etc.

  Actual result: Cursor keys are passed in as usual

- The multitouch trackpad only works if bcm5974 is loaded before usbhid
  -> otherwise only left click works

- If bcm5974 is loaded before usbhid, left moving the mouse while
  holding down the mouse button (i.e. the trackpad) does not work,
  but results in a right click

Anyone a pointer on how to fix these issues?

Cheers,

Nico

-- 
PGP key: 7ED9 F7D3 6B10 81D7 0EC5  5C09 D7DC C8E4 3187 7DF0
