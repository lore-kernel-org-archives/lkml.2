Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753695Ab1AOSen (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jan 2011 13:34:43 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:55733 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752766Ab1AOSem convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jan 2011 13:34:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=FAh7xhazgKJqIXUT3oqd85xqUq7CqV4yX5ey4SVgUraH4E987rsNXn3JFo5NuGKnhA
         B8tIu8G4yNrojeLaIZB078wJSr32prvo4grgNgin4EmObrvZKXGv9nyg59abuIYJqjhF
         rfAFg3U0qYim3vuSHEpyQTKEKc5RmTO/whxG0=
MIME-Version: 1.0
Date: Sat, 15 Jan 2011 19:34:41 +0100
Message-ID: <AANLkTinHOFwPCwJNCy9cFMCf+_VNb-7YFk-3VJFXoaoZ@mail.gmail.com>
Subject: NETLINK: Failed to browse: Invalid argument from avahi-daemon in F14
 since 2.6.37-git8
From: Alessandro Suardi <alessandro.suardi@gmail.com>
To: linux-kernel@vger.kernel.org, netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

/var/log/messages says:

Jan 13 12:42:02 duff avahi-daemon[2771]: Found user 'avahi' (UID 70)
and group 'avahi' (GID 70).
Jan 13 12:42:02 duff avahi-daemon[2771]: Successfully dropped root privileges.
Jan 13 12:42:02 duff avahi-daemon[2771]: avahi-daemon 0.6.27 starting up.
Jan 13 12:42:02 duff avahi-daemon[2771]: Successfully called chroot().
Jan 13 12:42:02 duff avahi-daemon[2771]: Successfully dropped
remaining capabilities.
Jan 13 12:42:02 duff avahi-daemon[2771]: Loading service file
/services/ssh.service.
Jan 13 12:42:02 duff avahi-daemon[2771]: Loading service file
/services/udisks.service.
Jan 13 12:42:02 duff avahi-daemon[2771]: NETLINK: Failed to browse:
Invalid argument
Jan 13 12:42:23 duff acpid: starting up with netlink and the input layer


Happens both at boot and after boot if restarting avahi-daemon service,
 and there is a 10-15" wait before the service start script prints a [FAILED]
 red tag; avahi-daemon process does start up anyways.

-git7 is the latest "good" kernel
-git8, -git9, -git11, -git13 have been reproducing the issue


thanks, ciao,

--alessandro

 "There's always a siren singing you to shipwreck"

   (Radiohead, "There There")
