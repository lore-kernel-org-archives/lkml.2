Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752328Ab0K1Kb4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Nov 2010 05:31:56 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:37663 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751782Ab0K1Kbx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Nov 2010 05:31:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=dFSKGzYTe57IyWjHWqED92DTf9na8CVLlcRVqscwPwCzH8gxzZINTkQ3gQUfa9j4CA
         QRNrnIo+bGANs16S3M3DjytVkiseL4o8WNXSCLUrdt6fe0MKzg/YEfBBBUVlHY5a/AL8
         dAxSC7KpYgY6YiPkcQSDcUjrH1qI7wNE2U2jo=
MIME-Version: 1.0
Date: Sun, 28 Nov 2010 11:31:52 +0100
Message-ID: <AANLkTi=owK=WZW4oNtpm5WpAZhqCQUdTR2K5gzJ_MqZ+@mail.gmail.com>
Subject: Fanotify mv/rename?
From: Axel Kittenberger <axkibe@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

I was just installing 2.6.37-rc3 to incorporate the brand new, cool
looking fanotify interface into Lsyncd,
http://code.google.com/p/lsyncd/ . It uses so far inotify to
continously rsync changes of a local directory tree to backups/live
mirrors, etc. Fanotify looked very nice at first, since inotify with 1
watch per dir can eat up quite some memory when watching *hugh*
directory trees. Additionally we made also Gedankenexperiments if
fanotifies Deny feature could be used for race-condition-safe
Master-Master synchronizations. But Alas, there are no move/rename
events in fanotify! I know it was designed with the virus shields in
mind and not observing/sync tools like Lsyncd, but I really hoped it
would be the (better?) Linux way of OSX' /dev/fsevents which does
feature mv's. Are there are any plans for MOVE events? Don't want to
add pulling other peoples carpet, but I'd rather wanted to see it
delayed yet another version with moves than ever without.

Kind regards,
Axel
