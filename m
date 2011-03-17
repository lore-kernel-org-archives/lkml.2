Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752521Ab1CQAvB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 20:51:01 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:50192 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752047Ab1CQAu4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 20:50:56 -0400
MIME-Version: 1.0
X-Originating-IP: [172.22.72.22]
Date: Wed, 16 Mar 2011 17:50:55 -0700
Message-ID: <AANLkTimXUSi6aEd97XSxsVguX926VPdbyhYEvBbL+wRD@mail.gmail.com>
Subject: [ANNOUNCE] Upstart 1.1 released
From: Scott James Remnant <scott@netsplit.com>
To: upstart-devel@upstart.at, upstart-release@upstart.at,
        Upstart Dev List <upstart-devel@lists.ubuntu.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nothing says "stable release" like a merry round of bug fixes,
including the file descriptor leak when the "script" keyword is used.


1.1  2011-03-16  "It's probably 'cause you think you're cooler than me"

	* When /sbin/halt is called (without -p), this now results in the
	  system being halted and not powered down. If you meant it to be
	  powered down, use /sbin/poweroff.  (Bug: #532366)

	* Fixed file descriptor leak of /proc/self/fd/NN to shell scripts
	  executed by Upstart.  (Bug: #619269)

	* Fixed bug where console was closed too early, causing loss of error
	  messages and non-functioning keyboard-request event,
	  (Bug: #707151)

	* Fixed bug where environment variables containing unusual characters
	  were not accepted due to a mis-reading of POSIX.  (Bug: #567068).

	* Fixed non-removal of symlinks on "make uninstall".  (Bug: #604227)

	* Reduced priority of job termination messages from warn to info
	  if the exit status or signal is listed in "normal exit".
	  (Bug: #522197)



The tarball can be found here:

       https://launchpad.net/upstart/1.x/1.1

For more information on upstart:

       http://upstart.at/


Scott
