Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755857Ab2FWEhJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2012 00:37:09 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:61910 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751713Ab2FWEhH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2012 00:37:07 -0400
MIME-Version: 1.0
Date: Sat, 23 Jun 2012 00:37:05 -0400
Message-ID: <CAK7t_7XoJ1iox4C2ZBc_fkzVgZ4G=i-QwPcZBXUPGcO+LqrYng@mail.gmail.com>
Subject: Porting older Harvard architecture kernel patch to latest stable
 kernel (3.4.4)
From: Vikram Dhillon <opensolarisdev@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: mingo@kernel.org, jiang@cs.ncsu.edu, dxu@cs.purdue.edu
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[cc'ing Ingo for the NX-bit similarity in the patch and the authors of
the paper]

Hi all,

I recently came across a code injection prevention framework [2] (and
the paper related to it [1]) that patches a kernel to emulate a
Harvard architecture whereby the authors of the paper show in [1] that
code injections don't have any affect. One of the features of this
patch is the non-executable pages (similar to the NX-bit provided by
processors) provided to provide the separation between code and data.
If you notice the patch that is present in [2] is for 2.6.13 and I
know that they have been _many_ changes to the APIs and such since
then, so where can I find more information on how to port this patch
to the latest stable kernel? I realize parts of the patch are obsolete
however newer API which can remove some of the clutter from the
original patch. Is there a script that can be used to map some of the
API so I can replace those parts or is it just trial and error? Thanks
for your time. (I can attach the patch from the archive if needed, I
didn't add it because I'm cc'ing other people)

[1] http://friends.cs.purdue.edu/pubs/dsn07-codeinj.pdf
[2] http://friends.cs.purdue.edu/projects/codeinj/get.php
[3] http://friends.cs.purdue.edu/dokuwiki/doku.php?id=code_injection

Vikram
