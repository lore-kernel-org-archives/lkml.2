Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751871Ab0FFWfw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jun 2010 18:35:52 -0400
Received: from mx3.orcon.net.nz ([219.88.242.53]:54498 "EHLO mx3.orcon.net.nz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750717Ab0FFWft (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jun 2010 18:35:49 -0400
Message-ID: <4C0C22C4.3010705@orcon.net.nz>
Date: Mon, 07 Jun 2010 10:35:48 +1200
From: Michael Cree <mcree@orcon.net.nz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100411 Icedove/3.0.4
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Borislav Petkov <borislav.petkov@amd.com>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-alpha@vger.kernel.org
Subject: 2.6.35-rc2 compilation error on Alpha
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
X-DSPAM-Check: by mx3.orcon.net.nz on Mon, 07 Jun 2010 10:35:48 +1200
X-DSPAM-Result: Innocent
X-DSPAM-Processed: Mon Jun  7 10:35:48 2010
X-DSPAM-Confidence: 0.6735
X-DSPAM-Probability: 0.0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When compiling 2.6.35-rc2 for Alpha architecture the following compiler 
error is seen:

   CC      arch/alpha/kernel/asm-offsets.s
In file included from include/linux/kernel.h:17,
                  from include/linux/sched.h:54,
                  from arch/alpha/kernel/asm-offsets.c:9:
include/linux/bitops.h: In function ‘hweight_long’:
include/linux/bitops.h:49: error: implicit declaration of function 
‘__arch_hweight32’

Cheers
Michael.
