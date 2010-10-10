Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755315Ab0JJQaQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Oct 2010 12:30:16 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:51675 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751233Ab0JJQaO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Oct 2010 12:30:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=xknnIWePrhw3QcrYLoeReFAPitg92TP0FzqrImdwpIduXc0AZfbkkog1T8VYlOS9tw
         UkrUaVnmkfUUVgJtXfQIPhREiVJrRxlom9/Y8kNjJdBFBpo8e4bn3k/JXZzrz/OqZ7Wj
         NP1JuvouS/g33FEQqFiABIR6VZtoJOfa80Qw4=
Message-ID: <4CB1E953.9070407@gmail.com>
Date: Sun, 10 Oct 2010 18:26:59 +0200
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; it; rv:1.9.1.9) Gecko/20100317 SUSE/3.0.4-1.1.1 Thunderbird/3.0.4
MIME-Version: 1.0
To: Linux Kernel <linux-kernel@vger.kernel.org>
CC: Linux Embedded <linux-embedded@vger.kernel.org>,
        Tim Bird <tim.bird@am.sony.com>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>
Subject: [PATCH 00/16] pramfs: persistent and protected RAM Filesystem
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

after a lot of improvement, test, bug fix and new features, it's the
moment for third round with the kernel community to submit PRAMFS for
mainline.

Since the last review (June 2009) a lot of things are changed:

- removed any reference of BKL
- fixed the endianess for the fs layout
- added support for extended attributes, ACLs and security labels
- moved out any pte manipulations from fs and inserted them in mm
- implemented the new truncate convention
- fixed problems with 64bit archs

...and much more. Complete "story" in the ChangeLog inserted in the
documentation file.

In addition, in the web site tech page (http:\\pramfs.sourceforge.net),
you can find a lot of information about implementation, technical
details, benchmarking and so on.

All the work to mainline this feature is sponsored by the CE Linux Forum.

Regards,
Marco
