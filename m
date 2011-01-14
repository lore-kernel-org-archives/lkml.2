Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758123Ab1ANTjt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 14:39:49 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:48768 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752562Ab1ANTjs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 14:39:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=U9K1XVKAsY9ZoU5blf+h7IwenBH4OniRreAp66SOk95ZB42X2fbLu8y6M2UbMGzUa6
         uYURYWchRnkFhb0ZlWXy7SXhXQ95yVg7YR0R3WFgYJ2fmGSs/eVdY3Ccoego7zASyN1V
         mJQZdGWxmDPYY4D56Ls/1/26xMzvWFcij1mok=
MIME-Version: 1.0
Date: Fri, 14 Jan 2011 21:39:47 +0200
Message-ID: <AANLkTi=4AeqYHR6LS8MzaZ42raMrkTvE2H4pUgGzNvBo@mail.gmail.com>
Subject: Build failure: smbfs
From: Anca Emanuel <anca.emanuel@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Greg KH <gregkh@suse.de>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  CC [M]  drivers/staging/smbfs/dir.o
  CC [M]  drivers/usb/atm/speedtch.o
drivers/staging/smbfs/dir.c:286: error: static declaration of
‘smbfs_dentry_operations’ follows non-static declaration
drivers/staging/smbfs/proto.h:42: note: previous declaration of
‘smbfs_dentry_operations’ was here
drivers/staging/smbfs/dir.c:294: error: static declaration of
‘smbfs_dentry_operations_case’ follows non-static declaration
drivers/staging/smbfs/proto.h:41: note: previous declaration of
‘smbfs_dentry_operations_case’ was here
make[4]: *** [drivers/staging/smbfs/dir.o] Error 1
make[3]: *** [drivers/staging/smbfs] Error 2
make[2]: *** [drivers/staging] Error 2
