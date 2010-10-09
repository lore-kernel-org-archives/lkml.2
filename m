Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759964Ab0JIAFp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 20:05:45 -0400
Received: from asmtpout023.mac.com ([17.148.16.98]:53905 "EHLO
	asmtpout023.mac.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759808Ab0JIAFo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 20:05:44 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=us-ascii
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0
 ipscore=0 suspectscore=5 phishscore=0 bulkscore=0 adultscore=0 classifier=spam
 adjust=0 reason=mlx engine=6.0.2-1004200000 definitions=main-1010080176
X-Proofpoint-Virus-Version: vendor=fsecure
 engine=2.50.10432:5.2.15,1.0.148,0.0.0000
 definitions=2010-10-08_17:2010-10-08,2010-10-08,1970-01-01 signatures=0
Subject: Re: kgdb errors with serial console
From: Elvis Dowson <elvis.dowson@mac.com>
In-reply-to: <4CAF19FA.7010206@windriver.com>
Date: Sat, 09 Oct 2010 04:05:16 +0400
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>
Message-id: <C07919DD-643F-4645-A261-91FB8F381A2C@mac.com>
References: <BDD07355-7199-4A2E-8426-F6D43EA5D313@mac.com>
 <4CAE4BB6.7080509@windriver.com>
 <7BA01CAF-DD25-4AB6-9498-8AB89E2EDDE1@mac.com>
 <4CAE5B40.3070701@windriver.com>
 <917F9CCC-F3D3-4E23-B955-412F08CE8E2E@mac.com> <4CAF19FA.7010206@windriver.com>
To: Jason Wessel <jason.wessel@windriver.com>
X-Mailer: Apple Mail (2.1081)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jason,
                   Perhaps the debugger is timing out because it doesn't get a break point to debug a specific event? 

Could you tell me the order in which I should try it? 

I think earlier on, when I used the kgdbwait bootarg, it ran and initialized eclipse debugger. Then when I entered the 

echo g > /proc/sysrq-trigger

it just activated the debugger correctly because the kgdb_breakpoint method was called in file kgdb.c

So, what should I do to test this? Do I write a small file, and add a call to kgdb_breakpoint in that example file, and then when I execute it, the debugger would get activated? 

Is there any other test that I can run, without writing my own example ?

Best regards,

Elvis
