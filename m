Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753210Ab2HTM0z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 08:26:55 -0400
Received: from smtp.extricom.com ([192.114.46.18]:54376 "HELO
	smtp.extricom.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with SMTP id S1752480Ab2HTM0Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 08:26:16 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Mon, 20 Aug 2012 08:26:15 EDT
Message-ID: <50322B55.5030106@extricom.com>
Date: Mon, 20 Aug 2012 15:19:33 +0300
From: leonid <leonid@extricom.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: myri10ge in p4080ds ppc
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi
This is my first mail in this group , so I hope this is the right place 
for it.

I am testing myri10ge pci-e (10G ethernet card) on p4080(freescale 
powerpc) evaluation board.
using kernel 2.6.34.6
when I am trying to insert myri10ge kernel module, I getting :
"myri10ge: Version 1.5.2-1.459
myri10ge 0001:03:00.0: invalid sram_size -33B or board span 16777216B "

it is looks like sram_size value is garbage read from the device .

any idea ?

reference:
myri10ge - https://www.myricom.com
p4080ds - 
http://www.freescale.com/webapp/sps/site/prod_summary.jsp?code=P4080DS
