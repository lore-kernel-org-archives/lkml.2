Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756746Ab2CVLjV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 07:39:21 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53669 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752476Ab2CVLjU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 07:39:20 -0400
Message-ID: <4F6B0F66.40505@canonical.com>
Date: Thu, 22 Mar 2012 11:39:18 +0000
From: James Hunt <james.hunt@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:11.0) Gecko/20120313 Thunderbird/11.0
MIME-Version: 1.0
To: "upstart-devel >> Upstart Devel List" 
	<upstart-devel@lists.ubuntu.com>,
        linux-kernel@vger.kernel.org
Subject: Upstart 1.5 released
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Summary of changes:

* Lots of "console log" improvements (and new tests).

* New 'early logging' facility which allows jobs that end before the
  log disk is writeable to have their output peristed to disk when the disk
  later becomes writeable.

* Upstart is now able to detect jobs which leak file
  descriptors: a message is generated when run with debug enabled
  ('--debug' / "initctl log-priority debug").

* New "usage" stanza which allows instance jobs to display a usage
  message explaining how job should be started. The usage is displayed
  when the user has not specified the correct variables to allow the job
  to be started, or when the user queries the usage using
  "initctl usage <job>".

Download it from launchpad: https://launchpad.net/upstart

Kind regards,

James
- --
James Hunt
____________________________________
http://upstart.ubuntu.com/cookbook
http://upstart.ubuntu.com/cookbook/upstart_cookbook.pdf
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQIcBAEBAgAGBQJPaw9lAAoJEJ1Q4UTmNXMn/y4QAJUkxQ88FlN4Hsu3zKOhSJWs
0VXeSLRlmNhWNdK52A1iZO/BshjaEGrpWICTjNmlY7OWJvey2JxNgF24O9kAqAIK
jxXsn1H3QWAceot8t0KxHEeFqToGeJaPzAh+SXMnlHItp0S8PAAsE2zmrlw06buI
yBvDOk5BG4SGeBj4o2fiDC1zGd3d8XWH3cJhi7vpqUniiXAYJFw5HGLUJYCxFmff
L2VFiAX0gn0KNAFVrbQDpYBRq4ZegUc4H0FQUjWNpOWU6v4jZ0rZmWD/7ETmgpkk
fDRpq65La8HrP+LlY4VM74POkOk18QQJGiM1jpXWv0fq6z5tRUGMjnpfUigOuGiw
7Ws749NpKApjiUh2azON89tS0Vb3IQdW0zGdjsL9FOQ+B6u03PbmSwMa/JkMSYh0
+OkOhK17Lx/6ooHnW6Sr83Q/5WhEMsBacLOSi0nCJJlrJLS9K/vINDCR6iQqsl1B
ixe6FsdCxdQSE7aCt2euIi5AKTWOoMzEi8gu6me0mF7XTT7ezpxbcc6n7vAE2X7C
iOluM13DgeZH9Zmf9/q8v39HQ9vi5FT+DC0hmM/UQQB/XNfiLJtpLzysOZV0sfq/
6jN1B/UdgAjHbzwmkeUY/jWGwDvamEGDw38xb/As+g7gt+TxuICOfqBfOE142t19
MDDAq/1NcMWYzJSwbE27
=6nMB
-----END PGP SIGNATURE-----
