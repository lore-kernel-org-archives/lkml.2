Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753382Ab1BMHfc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Feb 2011 02:35:32 -0500
Received: from mail-qy0-f181.google.com ([209.85.216.181]:49624 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751718Ab1BMHf0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Feb 2011 02:35:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:date:message-id:subject:from:to:cc
         :content-type;
        b=nSOp6tBfdf4LR0GAu8EDNEczCv+THtu2Ug4dnXZF+rym3qoKoX2Dl9WwsEKNSj8X/P
         yi8ZOZB3d21xI8RBMT27NWWH+GMSiksQEw5oGIEk8vumiY6RdQQKAfSU6rU3OwtoUUET
         XJJxYpoqwk7maj5QYwg22W8Q+YtuDSmtf0whI=
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
Date: Sun, 13 Feb 2011 08:35:23 +0100
Message-ID: <AANLkTinfTjPKc=MU6-qKmCYZDtCNjV9O_1v=gf7X2qaF@mail.gmail.com>
Subject: Re: [GIT PULL] ext4.git#for_linus
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: linux-ext4@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I pulled 24hrs ago ext4.git#for_linus into my local linux-next tree.
What happened to Dan's patch?

Dan Carpenter (1):
      ext4: off by one check in ext4_groupinfo_create_slab()

This patch was in the first pull-request [1],  but did not find its
way to Linus-tree.
Intention or forgotten?

Regards,
- Sedat -

[1] http://marc.info/?l=linux-ext4&m=129743167006873&w=2
