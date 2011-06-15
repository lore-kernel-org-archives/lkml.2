Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756079Ab1FOQ1X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 12:27:23 -0400
Received: from adelie.canonical.com ([91.189.90.139]:53448 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754715Ab1FOQ1X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 12:27:23 -0400
Message-ID: <4DF8DD69.3010406@ubuntu.com>
Date: Wed, 15 Jun 2011 17:27:21 +0100
From: James Hunt <james.hunt@ubuntu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) Gecko/20110516 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Upstart 1.3 released (yesterday :)
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A plethora or new features and updates, including all those from Ubuntu Natty.

* New upstart-socket-bridge application which allows jobs to be
  started when an incoming client socket connection is initiated
  (requires a suitably modified server daemon since jobs only
  need call accept(2) before reading from the socket).
* User session support allowing non-privileged users to
  manipulate their own jobs (not available within a chroot
  environment).
* Chroot support allowing jobs to be controlled within chroot
  environments.
* Updated bash completion script.
* Updated vim syntax script.
* init-checkconf script used to check syntax of Job
  Configuration Files (including script sections).
* initctl2dot script to convert initctl(8) output to GraphViz
  dot(1) format for analysing relationships between jobs and
  events.
* New "check-config" initctl command to check for jobs whose
* "start on" and "stop on" events cannot be satisfied.
* New "show-config" initctl command to display "start on", "stop
  on" and emits" information in parseable format.
* New initctl command-line option: "--session" for D-Bus
  session connection.
* New init command line options (mostly for testing):
  - "--session" for D-Bus session bus.
  - "--confdir <dir>".
  - "--startup-event <event>".
  - "--no-startup-event".
* New "kill signal" stanza to allow override of SIGTERM when
  stopping jobs.
* Add support for the oom_score_adj procfs API.
* Improved POSIX compliance when running shell scripts.


The tarball can be found here:

	https://launchpad.net/upstart/1.x/1.3

For more information on upstart:

	http://upstart.at/
	http://upstart.ubuntu.com/


Regards,

James Hunt
