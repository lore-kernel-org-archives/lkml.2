Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758216Ab0JELjQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 07:39:16 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:49304 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751815Ab0JELjP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 07:39:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=hjCybO0ADcOuIOg3qMz/L+72iS+n6vNfTLHzq2GduP1Zwdvty3VBO9an48jDDJQ6D4
         30hj1AQ7/B/u0x5q/VYCMBeOzghbmlDhe2lQcuoGaPYS0CDkXIBhezYyOqnjLRqcg9IM
         1Jql+XrbkYwbVeh7EE3RoA3Mi3x9/4Zb2ADEs=
MIME-Version: 1.0
Date: Tue, 5 Oct 2010 13:39:14 +0200
Message-ID: <AANLkTik34ZKasZMMpx4wD71k+RPccGLvAi1Cwe5UwZpj@mail.gmail.com>
Subject: [PATCH] pramfs: Persistent and protected RAM filesystem
From: Marco Stornelli <marco.stornelli@gmail.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: linux-embedded@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Tim Bird <tim.bird@am.sony.com>, linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

after a lot of improvement, test, bug fix and new features, it's the
moment for third round with the kernel community to submit PRAMFS for
mainline. First of all, I have to say thanks to Tim Bird and CELF to
actively support the project.

Since the last review (June 2009) a lot of things are changed:

- removed any reference of BKL
- fixed the endianess for the fs layout
- added support for extended attributes, ACLs and security labels
- moved out any pte manipulations from fs and inserted them in mm
- implemented the new truncate convention
- fixed problems with 64bit archs

...and much more. Complete "story" in the ChangeLog inserted in the
documentation file.

Since the patch is long, you can download and review the patch from
the project site: http:\\pramfs.sourceforge.net. The patch version is
1.2.1 for kernel 2.6.36.
In addition, in the web site tech page, you can find a lot of
information about implementation, technical details, benchemarking and
so on.

Regards,

Marco
