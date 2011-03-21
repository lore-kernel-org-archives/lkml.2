Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752884Ab1CUMZo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 08:25:44 -0400
Received: from smtp-5.star.net.uk ([212.125.75.74]:47439 "HELO
	smtp-5.star.net.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751563Ab1CUMZm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 08:25:42 -0400
From: Steve Allen <Steve.Allen@acalsupplychain.com>
To: "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>
Date: Mon, 21 Mar 2011 12:25:05 +0000
Subject: 2.6.37 kernel poor sg(x) driver scsi hard drive performence
Thread-Topic: 2.6.37 kernel poor sg(x) driver scsi hard drive performence
Thread-Index: Acvnud3iDm+VayCpR12CADP7oPRNNQACPwxw
Message-ID: <B78676C11D549249AB29226D36F4140613563537DE@WOK-SRV-020.acalsupplychain.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

My first post, apologies if asking the wrong question in the wrong place. E=
ndeavoured to be correct, read FAQ & searched mailing lists.

I have a specific use of linux as a scsi hard drive test environment. I hav=
e been using knoppix with kernel 2.6.28.4 for a number of years very sucess=
fuly.
I test 14 drives simultaneously in an external drive bay using for example =
scsi write-same erase command. Although we use a product from santools, sma=
rtmon-ux,
 sg_write_same is available form scsitools etc.

I have updated to knoppix 6.4.4 with kernel 2.6.37 and cannot test in the s=
ame manner, the performance makes the test operation impractical.
Although, I can test one drive at a time under  2.6.37 with the same test t=
ime as 2.6.28.4,   as soon as I load additional drives the test times sore =
from 18m to 134m.

I have tried googling and come across I/O throttling. Am I on the right lin=
es?
I have attempted to research cgroups but the info is mainly on limiting thr=
oughput.

Any ideas would be appreciated, happy to run any tests etc.
Many reasons why I would like to keep 2.6.37

Regards,

SteveA
