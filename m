Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754670Ab1E2QI7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 May 2011 12:08:59 -0400
Received: from isrv.corpit.ru ([86.62.121.231]:57978 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751049Ab1E2QI6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 May 2011 12:08:58 -0400
Message-ID: <4DE26F97.9050607@msgid.tls.msk.ru>
Date: Sun, 29 May 2011 20:08:55 +0400
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.16) Gecko/20110506 Icedove/3.0.11
MIME-Version: 1.0
To: Linux-kernel <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: unlink(nonexistent): EROFS or ENOENT?
X-Enigmail-Version: 1.0.1
OpenPGP: id=804465C5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Just noticed that at least on ext4, unlinking a
non-existing file from a read-only filesystem
results in EROFS instead of ENOENT.  I'd expect
it return ENOENT - it is more logical, at least
in my opinion.

For one, (readonly) NFS mount returns ENOENT in
this case.

Thanks!

/mjt
