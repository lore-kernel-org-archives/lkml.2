Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756747Ab0LMDl1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 22:41:27 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:63113 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756674Ab0LMDlZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 22:41:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=lwVCRmlUiUZ0ulMIopwYlXlXcHGKnNb+2pnHxgSxd2FR43ENmSkjuWAozKKALVudLK
         MlWM+hG9rmN0Bzt2drqUbc87NWF3wZtuhxTLnM0cHel8VUUJHOQx3fTc6Yz5yMxqNElA
         yyx0BtGHCCQL6k0LX4Q49Q/Nky9KAD+lJCcHA=
Message-ID: <4D0595DE.5050903@garzik.org>
Date: Sun, 12 Dec 2010 22:41:18 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: linux-crypto@vger.kernel.org
CC: LKML <linux-kernel@vger.kernel.org>,
        Herbert Xu <herbert@gondor.hengli.com.au>
Subject: [CRYPTO] skein hash updated
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've been quietly maintaining a Linux kernel implementation of the 
'skein' hash algorithm, which is one of the proposed SHA-3 algorithms. 
First posted around two years ago: 
http://www.mail-archive.com/linux-crypto@vger.kernel.org/msg02373.html

Skein is currently at version 1.3, and as slashdot readers are aware, 
skein is one of the finalists for SHA-3.

The git URL remains unchanged:  branch "skein" of
git://git.kernel.org/pub/scm/linux/kernel/git/jgarzik/misc-2.6.git

Thanks to Tobias Karnat for recent updates, including conversion to shash.

