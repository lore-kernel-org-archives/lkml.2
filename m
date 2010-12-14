Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759657Ab0LNQ4O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 11:56:14 -0500
Received: from mail-fx0-f43.google.com ([209.85.161.43]:33861 "EHLO
	mail-fx0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759645Ab0LNQ4M convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 11:56:12 -0500
MIME-Version: 1.0
X-Originating-IP: [91.189.88.12]
Date: Tue, 14 Dec 2010 16:56:10 +0000
Message-ID: <AANLkTikrjfKJOSmUDmQqQkohg5Stt941ZvypHAUsYYq5@mail.gmail.com>
Subject: [ANNOUNCE] upstart 0.6.7 released
From: Scott James Remnant <scott@netsplit.com>
To: upstart-devel@lists.ubuntu.com, upstart-devel@upstart.at,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Support for disabling a job without deleting the file or commenting
out the "start on" stanza; some new D-Bus properties and signals and
documentation improvements.


0.6.7  2010-12-14  "Return of the Mole"

	* A new "manual" stanza has been added to the configuration, this
	  removes any previously defined "start on" stanza for job so that
	  the job can only be started with initctl "start".  This allows
	  quick disabling of a job with:

		echo "manual" >> /etc/init/jobname.conf

	* Upstart now emits a "GoalChanged" D-Bus signal immediately after
	  changing the "goal" property of an instance, a "StateChanged"
	  signal after changing the "state" property, and a "Failed" signal
	  after marking an instance as failed.

	* Job objects now include "start_on", "stop_on" and "emits"
	  properties containing the appropriate information from the
	  configuration.

	* For developers, a "debug" stanza has been added; if present in a
	  job, the job will wait before the exec call and can be attached
	  to by gdb to examine Upstart's state.

	* Manpage fixes.  (Bugs: #677392, #686734)


The tarball can be found here:

       http://upstart.ubuntu.com/download/

For more information on upstart:

       http://upstart.ubuntu.com/


Scott
