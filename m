Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933794Ab1AMUXP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 15:23:15 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:55881 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933746Ab1AMUXF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 15:23:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=kSjYyk96KtBKCsJV3cwmBCkIKMPR8u3DQGmCk7ZOn0T02mtamLaZ9zvR+u9OinZCnk
         IFZTetNQMlQaFvT0uMamyG0logGS8XYkg/nK9NITPiAP+0gfw+htzMTuubEKsTvSiZ1A
         AkmEa8Mf2Pjk0SMB8KTnCuqR/rQ4XOUMAEesM=
Subject: [BUG] ECRYPT_FS
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 13 Jan 2011 21:23:01 +0100
Message-ID: <1294950181.3403.9.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Al

FYI, current linux-2.6 is broken for CONFIG_ECRYPT_FS

commit 66cb76666d69502fe982990b2cff5b6d607fd3b1
Author: Al Viro <viro@zeniv.linux.org.uk>
Date:   Wed Jan 12 20:04:37 2011 -0500

  CC      fs/ecryptfs/main.o
fs/ecryptfs/main.c:144: error: expected ‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before ‘*’ token
fs/ecryptfs/main.c: In function ‘ecryptfs_interpose’:
fs/ecryptfs/main.c:204: error: implicit declaration of function ‘ecryptfs_get_inode’
fs/ecryptfs/main.c:204: warning: initialization makes pointer from integer without a cast
fs/ecryptfs/main.c:206: error: expected ‘)’ before ‘return’
fs/ecryptfs/main.c:212: error: expected expression before ‘}’ token
fs/ecryptfs/main.c: In function ‘ecryptfs_mount’:
fs/ecryptfs/main.c:569: warning: assignment makes pointer from integer without a cast


