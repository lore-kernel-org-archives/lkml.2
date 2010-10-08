Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759850Ab0JHWIT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 18:08:19 -0400
Received: from asmtpout023.mac.com ([17.148.16.98]:42623 "EHLO
	asmtpout023.mac.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753308Ab0JHWIS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 18:08:18 -0400
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0
 ipscore=0 suspectscore=5 phishscore=0 bulkscore=0 adultscore=0 classifier=spam
 adjust=0 reason=mlx engine=6.0.2-1004200000 definitions=main-1010080153
X-Proofpoint-Virus-Version: vendor=fsecure
 engine=2.50.10432:5.2.15,1.0.148,0.0.0000
 definitions=2010-10-08_16:2010-10-08,2010-10-08,1970-01-01 signatures=0
Subject: Re: kgdb errors with serial console
From: Elvis Dowson <elvis.dowson@mac.com>
In-reply-to: <4CAF19FA.7010206@windriver.com>
Date: Sat, 09 Oct 2010 02:07:59 +0400
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>
Content-transfer-encoding: 8BIT
Message-id: <FEFCC5ED-AFF1-4F97-B49C-BE3CFB96295B@mac.com>
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
                  There was a setting in Eclipse that allowed me to increase the timeout, located under Windows > Preferences > C/C++ > Debug

I increase the settings to 120000(ms) for the debugger time out and 60000(ms) for the launcher. 

So, it didn't time out, but it kept repeating the same sequence over and over again, I haven't yet set a break-point. 

$047089e5#d6+$60509fe5#04+$047089e5#d6+$60509fe5#04+$60509fe5#04+$60509fe5#04+$44d04de2#2b+$04001de3#f1+$04d04d02#f2+$60509fe5#04+$047089e5#d6+$60509fe5#04+$047089e5#d6+$60509fe5#04+$60509fe5#04+$60509fe5#04+$44d04de2#2b+$04001de3#f1+$04d04d02#f2+$60509fe5#04+$047089e5#d6+$60509fe5#04+$047089e5#d6+$60509fe5#04+$60509fe5#04+$60509fe5#04+$44d04de2#2b+$04001de3#f1+$04d04d02#f2+$60509fe5#04+$047089e5#d6+$60509fe5#04+$047089e5#d6+$60509fe5#04+$60509fe5#04+$60509fe5#04+$44d04de2#2b+$04001de3#f1+$04d04d02#f2+$60509fe5#04+$047089e5#d6+$60509fe5#04+$047089e5#d6+$60509fe5#04+$60509fe5#04+$60509fe5#04+$44d04de2#2b+$04001de3#f1+$04d04d02#f2+$60509fe5#04+$047089e5#d6+$60509fe5#04+$047089e5#d6+$60509fe5#04+$60509fe5#04+$60509fe5#04+$44d04de2#2b+$04001de3#f1+$04d04d02#f2+$60509fe5#04+$047089e5#d6+$60509fe5#04+$047089e5#d6+$60509fe5#04+$60509fe5#04+$60509fe5#04+$44d04de2#2b+$04001de3#f1+$04d04d02#f2+$60509fe5#04+$047089e5#d6+$60509fe5#04+$047089e5#d6+$60509fe5#04+$60509fe5#04+$60509fe5#04+$44d04de2#2b+$04001d

and then after sometime, stops with the timeout error. This is with kernel linux-omap-2.6.32. 

Here is the log file for this session:


w +$qSupported#37
r +$#00
w +$Hg0#df
r +$OK#9a
w +$?#3f
r +$S05#b8
w +$Hc-1#09
r +$OK#9a
w +$qC#b4
r +$QC00000000fffffffe#43
w +$qAttached#8f
r +$#00
w +$qOffsets#4b
r +$#00
w +$g#67
r +$140000009301008001000000844ec7c0acf16fc067000000010000000700000000e823cf00e823cf930100209301004020de58c0a8de58c0749409c0849409c00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000093010040#a9
w +$mc0099484,4#a2
r +$ffdeffe7#fd
w +$mc0099480,4#9e
r +$5ff07ff5#69
w +$mc0099484,4#a2
r +$ffdeffe7#fd
w +$mc0099480,4#9e
r +$5ff07ff5#69
w +$mc0099484,4#a2
r +$ffdeffe7#fd
w +$mc0099484,4#a2
r +$ffdeffe7#fd
w +$mc0099484,4#a2
r +$ffdeffe7#fd
w +$qSymbol::#5b
r +$#00
w +
c info proc
End of log

Best regards,

Elvis