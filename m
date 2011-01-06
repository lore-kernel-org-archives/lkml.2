Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753995Ab1AFUCF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 15:02:05 -0500
Received: from deluge.CC.McGill.CA ([132.206.27.50]:59783 "EHLO
	deluge.cc.mcgill.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752064Ab1AFUCC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 15:02:02 -0500
X-Greylist: delayed 1109 seconds by postgrey-1.27 at vger.kernel.org; Thu, 06 Jan 2011 15:02:02 EST
Subject: Boot failure in 2.6.37
From: David Ronis <ronis@ronispc.chem.mcgill.ca>
Reply-To: ronis@ronispc.chem.mcgill.ca
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Thu, 06 Jan 2011 14:43:29 -0500
Organization: Department of Chemistry, McGill University
Content-Type: text/plain; charset="ansi_x3.4-1968"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 2.91.2 
Message-ID: <1294343009.2679.5.camel@ronispc.chem.mcgill.ca>
Mime-Version: 1.0
X-PMX-Version: 5.4.2.338381, Antispam-Engine: 2.6.0.325393, Antispam-Data: 2011.1.4.131222
X-McGill-WhereFrom: Internal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I just upgraded 3 machines from version 2.6.36 to 2.6.37.  On one of
them, as it turns out, the oldest machine, rebooting hung (the other 2
are fine).  The last thing I see on the console is:

/dev/ttyS?: No such file or directory
Using /etc/random-seed to initialize /dev/urandom

(normally this is a box without a monitor, keyboard etc).

I couldn't login via ssh (no surprise) but several daemons were up and
running (the machine was pingable, mail was being received).

This is a noname, dual cpu Pentium III box running slackware 11.0.0.

Any ideas?

I don't subscribe to this list and would appreciated a CC on any
responses

Thanks in advance.


