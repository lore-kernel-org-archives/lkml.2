Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753846Ab2FSHsh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 03:48:37 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:49027 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753350Ab2FSHsg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 03:48:36 -0400
MIME-Version: 1.0
X-Originating-IP: [85.250.103.112]
In-Reply-To: <1340032915-10734-1-git-send-email-sjur.brandeland@stericsson.com>
References: <1340032915-10734-1-git-send-email-sjur.brandeland@stericsson.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Tue, 19 Jun 2012 10:48:15 +0300
Message-ID: <CAK=Wgbb9wXjb_-=31CCE9HUBqNaNM3eusPqjqbAorrMpW9YyLQ@mail.gmail.com>
Subject: Re: [PATCHv3 0/4] remoteproc: Custom firmware handling.
To: sjur.brandeland@stericsson.com
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        =?ISO-8859-1?Q?Sjur_Br=E6ndeland?= <sjurbren@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sjur,

On Mon, Jun 18, 2012 at 6:21 PM,  <sjur.brandeland@stericsson.com> wrote:
> This patchset is rebased to v3.5-rc3. I fixed some minor kernel-doc issues
> for fw_ops, and some commit messages.
> Otherwise there are no changes since last time.

Thanks! I fixed some minor issues (mostly kerneldoc and style),
applied and pushed.

I've also applied the below patch to let people know where the
for-next and fixes branches of remoteproc are maintained:

commit 5414687e1fde12b5bc8f77af79e766290900a228
Author: Ohad Ben-Cohen <ohad@wizery.com>
Date:   Tue Jun 19 10:22:35 2012 +0300

    MAINTAINERS: add remoteproc's git

    Add remoteproc's git tree to the MAINTAINERS entry

    Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 3e30a3a..5275ca9 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5708,6 +5708,7 @@ F:        include/linux/regmap.h

 REMOTE PROCESSOR (REMOTEPROC) SUBSYSTEM
 M:     Ohad Ben-Cohen <ohad@wizery.com>
+T:     git git://git.kernel.org/pub/scm/linux/kernel/git/ohad/remoteproc.git
 S:     Maintained
 F:     drivers/remoteproc/
 F:     Documentation/remoteproc.txt
