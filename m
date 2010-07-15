Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933503Ab0GOPHV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 11:07:21 -0400
Received: from web100113.mail.kks.yahoo.co.jp ([114.111.99.88]:21887 "HELO
	web100113.mail.kks.yahoo.co.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S933441Ab0GOPHS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 11:07:18 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Thu, 15 Jul 2010 11:07:17 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=yj20050223; d=yahoo.co.jp;
  h=Message-ID:Received:Date:From:Subject:To:MIME-Version:Content-Type;
  b=AMbDTlgWrAmKlw56xmgILYjIy/r2WFvwiJpwAXMdgePJkoCWaengy5lRgicWFHhbj9CxqX1hVCPCIpGPwEr0nTnzuTqB5XFU5mN8hs7QSpm1NkIY6FIb6hPpbpDekiO9  ;
Message-ID: <20100715150036.22283.qmail@web100113.mail.kks.yahoo.co.jp>
Date: Fri, 16 Jul 2010 00:00:36 +0900 (JST)
From: tanaka <tanaka_hideo@yahoo.co.jp>
Subject: Please teach me X86 I/O port 0x61 
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-2022-jp
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear all.

I investigate about  NMI kernel messages.
Linux kernel read 0x61 address using inb(61h).

I search a amd opteron cpu following manuals.
but I do not find  explanation of 0x61 address.

http://support.amd.com/us/psearch/Pages/psearch.aspx?type=2.1&product=2.1.4&contentType=Tech+Doc+Processor&ostype=&keywords=&items=20

Could you teach me a 0x61 address of X86 arch >

Best regards.

--------------------------------------
Get the new Internet Explorer 8 optimized for Yahoo! JAPAN
http://pr.mail.yahoo.co.jp/ie8/
