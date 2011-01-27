Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751358Ab1A0GCN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 01:02:13 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:64903 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750911Ab1A0GCM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 01:02:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=E77m7MI10ohici3GvvCyNgWe436rejfTc+nEN0wKl2i0rd74VcUt6/281JS6+Oo9gN
         B/McI2ctpDWDHw5GO9/bDAo8UBzcjrZ6ivGYpLe0thkqsH+ZSJ9vdQbXLaCf3IJylUH5
         DtCR2vvQniAU+HDh6qWOoScSfD9P1Abv0I4aU=
MIME-Version: 1.0
Date: Thu, 27 Jan 2011 11:32:11 +0530
Message-ID: <AANLkTimFGGgP-YYhRmJ=RfjfZO4mLKAVYvt_jMqhBswn@mail.gmail.com>
Subject: Stability of ecryptfs over NFS
From: Pallavi Joseph Kalpana <pallutai@gmail.com>
To: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This a question regarding stability of ecryptfs over NFS. I am posting
a question here as I observed that the ecryptfs mailing lists are not
very active.

The ecryptfs README says that stability with NFS is still under
progress. So is the problem with stability related to the stacking
model that ecryptfs is based on, or is it due to the
encryption/decryption complexity?

I tried running "ls" on a directory mounted over NFS. This works fine
for the first time but for subsequent attempts "ls" does not show any
output.

However, when I repeat the same operation over a mount over local
filesystems, ls works fine.

Is this a known problem?

Thanks,
Pallavi
