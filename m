Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757234Ab2AKLN6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 06:13:58 -0500
Received: from blade.4t2.com ([178.63.72.200]:56292 "EHLO blade.4t2.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756988Ab2AKLNo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 06:13:44 -0500
X-Greylist: delayed 581 seconds by postgrey-1.27 at vger.kernel.org; Wed, 11 Jan 2012 06:13:43 EST
Message-ID: <1326279818.24835.12.camel@utumno>
Subject: 3.2.0 reboot powers off machine
From: Tom Weber <l_linux-kernel@mail2news.4t2.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Date: Wed, 11 Jan 2012 12:03:38 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-4t2Systems-MailScanner-Information: processed at blade.4t2.com
X-4t2Systems-MailScanner-ID: 0BB9920AE5.ECF78
X-4t2Systems-MailScanner: Found to be clean
X-4t2Systems-MailScanner-From: l_linux-kernel@mail2news.4t2.com
X-4t2Systems-MailScanner-Watermark: 1327143828.42926@CVUBn2UiLXNyrwqH8ZPftA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

with 3.2.0 I end up with a powered down machine when trying to reboot.
shutdown -r, reboot, reboot -f, echo b > /proc/sysrq-trigger
will all result in power off.

3.1.8 reboots as expected.

64bit
Xeon E31240 CPU
Supermicro X9SCA-F Mainboard
(http://www.supermicro.nl/products/motherboard/Xeon/C202_C204/X9SCA-F.cfm)

dmidecode and both kernel configs at http://www.4t2.org/rebootinfo/

let me know if you need more info,
  Tom

