Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750955Ab0LKFg1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Dec 2010 00:36:27 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:36534 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750795Ab0LKFg0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Dec 2010 00:36:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=nok+bvCXCMudh0OILbQqBNhdMTdZ0CJhD2RT7aLF+8yI0fBxcQS6Pw1Yi1auTrOvVK
         FXZYiJdIJ/1UcULa3yv/IBtN9QzRxn9XHvwveldaDS9MqW06PDAh4qIjUmq2fguKmEgs
         GK1SaMZyMgx63s5/cI66TK0KmsHAVupH/s+bU=
Date: Sat, 11 Dec 2010 13:36:05 +0800
From: HarryWei <harryxiyou@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: CodingStyle Problem
Message-ID: <20101211053601.GA8683@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,
      I just read the CodingSyle at Documentation directory in linux-2.6.23 kernel source code.
      But a problem happened to me like following.
      Functions in linux-2.6.23/fs/fs-writeback.c are "static int" and function name are in different lines.(function name in following line)
      I can't find the rule in CodingStyle. That We often program functions are "static int" and function name are in the same line. 
      When do we do the first or second way? What is different between them?

  Any answer is okay.
  Best regards.
