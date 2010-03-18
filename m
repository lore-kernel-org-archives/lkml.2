Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754215Ab0CROmh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 10:42:37 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:59644 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753715Ab0CROmf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 10:42:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=YgY2KFxFlMqIwZERaQyx0G2hJ7/g6jMfzuUN7DAf+j7RUjc0kQaaob/Kod014wUK3L
         j2LAPXcGjiASFIfaeOl/pWFvzCowGrxfY2iP5G4lJ8rvAEZX0orX4aQusThZGkcApeep
         rIVhZzi3Tcgo075CXAEc+UltlTqk6f23eb2j8=
MIME-Version: 1.0
Date: Thu, 18 Mar 2010 15:42:33 +0100
Message-ID: <b2cc26e41003180742k435cbc7eqcf84a65791ee36c@mail.gmail.com>
Subject: execve() returns ENOENT when ld-linux.so isn't found
From: Olaf van der Spek <olafvdspek@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

When you try to execute an x86 binary on a x64 system, execve()
returns ENOENT when ld-linux.so isn't found
Wouldn't ENOEXEC be more appropriate?

> An executable is not in a recognized format, is for the wrong architecture, or has some other format error that means it cannot be executed.

This just doesn't make any sense:

$ ls -l
-rwxr-xr-x 1 olaf olaf 560165 2010-03-18 15:21 xwis
$ ./xwis
-bash: ./xwis: No such file or directory

Olaf
