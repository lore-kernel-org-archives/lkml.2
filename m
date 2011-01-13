Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933091Ab1AMSdh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 13:33:37 -0500
Received: from exprod7og105.obsmtp.com ([64.18.2.163]:52898 "HELO
	exprod7og105.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932812Ab1AMSdf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 13:33:35 -0500
X-Greylist: delayed 3191 seconds by postgrey-1.27 at vger.kernel.org; Thu, 13 Jan 2011 13:33:35 EST
From: Lawrence Manning <lawrence.manning@smoothwall.net>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Subject: Problem booting 2.6.32 built with gcc 3.3.5
Date: Thu, 13 Jan 2011 17:29:45 +0000
Message-Id: <C62021DB-A2F8-4A89-82B3-9FC38C19F329@smoothwall.net>
To: linux-kernel@vger.kernel.org
Mime-Version: 1.0 (Apple Message framework v1082)
X-Mailer: Apple Mail (2.1082)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi list,

I am unable to boot a 2.6.32 vanilla kernel when it is built with a toolchain based off gcc 3.3.5.  When building this kernel on gcc 4.2.4 it boots happily.  The config file remains unchanged.  I can supply this config file if anyone thinks it would be useful.

The problem seems to be related to the decompress code in arch/x86/boot/compressed/misc.c.  When booting the kernel built with gcc 3.3.5 I see a message:

Destination address too large -- System halted

I've tried this kernel on virtual box and on physical hardware with the same results.  The gcc 3.3.5 chain is able to properly build earlier kernels, 2.6.16.* specifically.

Has anything changed with regard to recommended compilers on newer kernels?  I assume most people build there kernels with gcc 4, but is gcc 3 still tested?

Any help gratefully appreciated.  I'm not on the list, so please keep me in the CC.

-- 

Lawrence Manning
Lead Developer

lawrence.manning@smoothwall.net

Smoothwall Ltd
1 John Charles Way, Leeds, LS12 6QA United Kingdom 
Telephone:  USA: 1 800 959 3760  Europe: +44 (0) 8701 999500
www.smoothwall.net

Smoothwall Limited is registered in England, Company Number: 4298247.  This email and any attachments transmitted with it are confidential to the intended recipient(s) and may not be communicated to any other person or published by any means without the permission of Smoothwall Limited.  Any opinions stated in this message are solely those of the author.

