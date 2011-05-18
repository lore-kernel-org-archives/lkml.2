Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753403Ab1ERUcw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 16:32:52 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:54396 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752675Ab1ERUcv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 16:32:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=N47MPHymWskuqnGzjSUkGJPW8NFQP/y7wdwn7/HbNMEq4GDu0BBpao+M+BePNmTGrj
         LBUq2pBW1JdLA9r/KmkVq0FxlMDyc7h5Yu0sD/mUJ1o+cGexxcTIpbMHRviaQn+tSJO7
         J/Cku/jGqi0VmX6StUTjz0kmlV/dZWqA2VD4c=
MIME-Version: 1.0
Date: Wed, 18 May 2011 13:32:50 -0700
Message-ID: <BANLkTin3T8msxSSbTLJOvC5WLNFGspPEcg@mail.gmail.com>
Subject: New boot time message: detected capacity change
From: Tony Luck <tony.luck@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Today's pull from Linus' tree (HEAD = 258-ga2b9c1f) gave me some new
messages during boot:

sda: detected capacity change from 0 to 146815737856
sdb: detected capacity change from 0 to 146815737856

They weren't there yesterday (HEAD = 211-gc1d10d1) ... nor do they
show up in any of my saved boot time dmesg files for the last few
months.

Harmless?  Or something to worry about in the last few commits
before 2.6.39 goes final?

-Tony
