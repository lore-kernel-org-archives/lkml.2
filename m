Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755721Ab1EXLtG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 07:49:06 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:39448 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755041Ab1EXLtE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 07:49:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:date:x-google-sender-auth:message-id:subject
         :from:to:content-type;
        b=X2uR2CTmSRqGE9GUa3LvXWhZ48soZI1x689HrCHTVdy55UXUrvDkENIHFR0c75WEOg
         GQdPEx1vAlBCOviLDeBL74PDM7TiL3cKyHiQHm3b/bAtSqbdLhC1y6JuM/0iz2C4aYNM
         KmF8ER0nX/2enM8vMFMGQZun2OQ2ukOq3QWsA=
MIME-Version: 1.0
Date: Tue, 24 May 2011 07:49:04 -0400
X-Google-Sender-Auth: 600sgxULWirQR8lK7vwbkqW8QTw
Message-ID: <BANLkTin4wu1HNDeo8Rv7iddM9KkgZdhfgA@mail.gmail.com>
Subject: UNIX Compatibility
From: Richard Yao <ryao@ic.sunysb.edu>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I know that the system call codes used by Linux are not 100% UNIX
compatible. Is there anything else in the kernel that is not UNIX
compatible? Would modifying these things for UNIX compatibility break
anything in userland provided that it is recompiled against the
modified sources?

By the way, I subscribed to the mailing because I heard that Linus
Torvalds is considering changing Linux's version scheme from 2.6.x to
3.x. Is there any possibility of putting better UNIX compatibility on
the list of features planned for 3.x?

Yours truly,
Richard Yao
