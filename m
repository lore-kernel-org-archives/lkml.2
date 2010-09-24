Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758490Ab0IXXja (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 19:39:30 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:40852 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753360Ab0IXXj3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 19:39:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=easuGEcanrONMw91tSPTyimtjXGU2FX8dQBkv9qQxX9KlCkkvWekWPmNB/VVEbPGN+
         DyUkihF35+qxEeCpGQQpxyfVwbHDu6KrvjiYs/imXRXRmbZBDs5c3iB7ZhUtOxM1hnyt
         TWlRvKJ3yQcPpJP9AVJr4a2JfsFdS/KpjNgyQ=
MIME-Version: 1.0
Date: Fri, 24 Sep 2010 19:39:28 -0400
Message-ID: <AANLkTiktbML6rHtTHKAmgP9xcZG-Dq362-Yc-_zJn18N@mail.gmail.com>
Subject: [PATCH v2 00/21] Staging: cleaned up makefiles cflag lines
From: T Dent <tdent48227@gmail.com>
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I changed every makefile in the staging directory to use the proper
ccflags-y option instead of EXTRA_CFLAGS and also changing the first
assignment to ":=" from "+=".


I couldn't change changing the first assignment to ":=" from "+=" for
the following four lines in rtl8192u Makefile r it wouldn't compile.
1.ccflags-y += -DTHOMAS_BEACON -DTHOMAS_TASKLET -DTHOMAS_SKB -DTHOMAS_TURBO
2.ccflags-y += -DUSE_ONE_PIPE
3.ccflags-y += -DENABLE_DOT11D
4.ccflags-y += -Idrivers/staging/rtl8192u/ieee80211



It builds  :) .

Thanks,
Tracey Dent
