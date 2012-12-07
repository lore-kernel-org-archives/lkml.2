Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1424211Ab2LGU1y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 15:27:54 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:45513 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1424191Ab2LGU1x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 15:27:53 -0500
Message-ID: <50C25146.9010909@ubuntu.com>
Date: Fri, 07 Dec 2012 20:27:50 +0000
From: James Hunt <james.hunt@ubuntu.com>
Reply-To: james.hunt@ubuntu.com
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: "upstart-devel >> Upstart Devel List" 
	<upstart-devel@lists.ubuntu.com>,
        linux-kernel@vger.kernel.org
Subject: Upstart 1.6.1 released
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Summary of changes:

* Improved re-exec performance.
* Minor logger fixes for unflushed data.
* Handle re-exec scenario when requested from within a chroot.
* Minor serialisation data format change to handle chroots and
  user sessions.
* Added extra re-exec tests including explicit upgrade tests reading
  from pre-prepared JSON data files.
* Make jobs running within a chroot log their output within the chroot.
* Added "Restart" D-Bus method.
* Changed 'telinit u' to use "Restart" D-Bus method rather than
  sending SIGTERM to play nicely when busybox(1) is init.
* Added "GetState" D-Bus method allowing current serialised internal state
  to be queried.

Thanks to all the contributors, reviewers, testers and users!

Download it from launchpad: https://launchpad.net/upstart

Kind regards,

James.
--
James Hunt
____________________________________
http://upstart.ubuntu.com/cookbook
http://upstart.ubuntu.com/cookbook/upstart_cookbook.pdf
