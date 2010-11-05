Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751453Ab0KEGLg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Nov 2010 02:11:36 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:38886 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750817Ab0KEGLd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Nov 2010 02:11:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=x14027tTCOcYBnnjm/GU5yw7cymKQAjjtIE4nHEZZT9URyIE3Ehd0oAkNps1Ll1Unb
         p4my6kXWOS9utpjX0jNClkeNzfwRsjPGB1W6kE7mHxC6w6GmaTXhV2CrlOHC0MzqnlIY
         FCymz/bUdmJJsP9gOsKPGRMsIKfc90LEaFa7M=
Date: Fri, 5 Nov 2010 14:16:10 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kbuild@vger.kernel.org
Subject: [Patch] gitignore: add scripts/recordmcount
Message-ID: <20101105061610.GA5213@cr0.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This file is generated, should be ignored by git.

Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>

---
diff --git a/scripts/.gitignore b/scripts/.gitignore
index c5d5db5..e2741d2 100644
--- a/scripts/.gitignore
+++ b/scripts/.gitignore
@@ -7,3 +7,4 @@ pnmtologo
 bin2c
 unifdef
 ihex2fw
+recordmcount
