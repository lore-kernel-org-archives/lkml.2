Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423657Ab2KOLzV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 06:55:21 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58245 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423250Ab2KOLzU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 06:55:20 -0500
Message-ID: <50A4D826.8050804@ubuntu.com>
Date: Thu, 15 Nov 2012 11:55:18 +0000
From: James Hunt <james.hunt@ubuntu.com>
Reply-To: james.hunt@ubuntu.com
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: "upstart-devel >> Upstart Devel List" 
	<upstart-devel@lists.ubuntu.com>,
        linux-kernel@vger.kernel.org
Subject: Upstart 1.6 released
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Summary of changes:

* 'telinit u' now performs a stateful re-exec, allowing
    Upstart to continue to supervise jobs after an upgrade
    of either itself, or any of its dependent libraries.
    Adds dependency on libjson (JSON-C).
* Added initramfs-less boot support.
* Allow tests to work in sbuild environment.
* Improved error handling.
* Fixed crasher if 'kill signal' specified as a particular
   numeric.
* Documentation fixes.

Thanks to the following for their contributions:

- A.Costa
- Colin Watson
- Eric S. Raymond
- Jason Conti
- Loïc Minier
- Steve Langasek

Download it from launchpad: https://launchpad.net/upstart

Kind regards,

James.
--
James Hunt
____________________________________
http://upstart.ubuntu.com/cookbook
http://upstart.ubuntu.com/cookbook/upstart_cookbook.pdf
