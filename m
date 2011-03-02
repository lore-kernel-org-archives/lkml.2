Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752307Ab1CBF25 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 00:28:57 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:52100 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751465Ab1CBF24 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 00:28:56 -0500
MIME-Version: 1.0
X-Originating-IP: [76.195.162.181]
Date: Tue, 1 Mar 2011 21:28:55 -0800
Message-ID: <AANLkTikcP6CKmpTrx160vV446z6kWL65ahPAyx-MOqqB@mail.gmail.com>
Subject: [ANNOUNCE] Upstart 1.0 released
From: Scott James Remnant <scott@netsplit.com>
To: Upstart Dev List <upstart-devel@lists.ubuntu.com>,
        upstart-devel@upstart.at, upstart-release@upstart.at
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The trouble with a "1.0" release is that the temptation is for that
version to be the one with all the features you want when your users
want it to be stable. This is a 1.0 release of the latter kind, based
on the 0.6.x code that was shipped in both the most recent Ubuntu LTS
and RedHat Enterprise Linux releases. If you're running Upstart
anywhere right now, it's highly recommended that you update to this
version, there shouldn't be any surprises!


1.0  2011-03-01  "This is a fertile land, and we will thrive"

	* Fixed an assertion when a file named /etc/init/.conf is created.
	  Discovered by Коренберг Марк (Bug: #720573)

	* utmp entries will be replaced with DEAD_PROCESS ones when a
	  pid supervised by Upstart terminates.  (Bug: #183729)

	* shutdown now correctly returns error code if it fails to shutdown
	  the system.

	* Included bash completion script in contrib directory.
          (Bug: #672067)


The tarball can be found here:

       https://launchpad.net/upstart/1.x/1.0

For more information on upstart:

       http://upstart.at/


Scott
