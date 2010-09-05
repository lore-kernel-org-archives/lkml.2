Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754831Ab0IEXFn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Sep 2010 19:05:43 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:48212 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750921Ab0IEXFm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Sep 2010 19:05:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:content-type:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=YpG8pgbLRIa40BAqkUZrM/YvpMBO7DJWhQNg2aGY6/iWXpKI43sGkwyr1lFktkCT3j
         fb6F2orljWNfVeoYvhTUkrrXRm169mHnLML+objNhsLP6DfxoeCgz5kF+uLZ3OAuRrU5
         GRBy7Fwr8ITFjKP+kjM84iWpDFG4chP785gQE=
Subject: ldd scull question about scull_device*
From: runcoderen <runcoderzhcn@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 06 Sep 2010 07:05:38 +0800
Message-ID: <1283727938.1758.12.camel@bencharluo-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi all:
when I am reading ldd(3rd) book about char device driver.
I have a question to ask:

I have seem the code in scull_init_module to create 4
scull_dev(scull_dev *).

but when I browse scull_write & scull_read function, I can see the code
only secure 1 scull_dev. and I don't know which scull_dev in scull_dev*
created before are I am using.

can anyone help me?

and why the author try to create 4 scull_device in scull_init_module?

					runcoderen

-- 

/****************************************
http://runcoderen.wordpress.com
****************************************/

