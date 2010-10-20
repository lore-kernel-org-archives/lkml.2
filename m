Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753874Ab0JTPbl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 11:31:41 -0400
Received: from na3sys009aog103.obsmtp.com ([74.125.149.71]:36983 "EHLO
	na3sys009aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753599Ab0JTPbk convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 11:31:40 -0400
From: "Yang, Bo" <Bo.Yang@lsi.com>
To: "Yang, Bo" <Bo.Yang@lsi.com>, bo yang <boyang1288@gmail.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "akpm@osdl.org" <akpm@osdl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "James.Bottomley@suse.de" <James.Bottomley@suse.de>
CC: "Daftardar, Jayant" <Jayant.Daftardar@lsi.com>
Date: Wed, 20 Oct 2010 09:31:10 -0600
Subject: RE: [PATCH 5/5] scsi: megaraid_sas - Version and documentation
 update
Thread-Topic: [PATCH 5/5] scsi: megaraid_sas - Version and documentation
 update
Thread-Index: ActazRK7LvyirE4SRzakFA0hPxKZqAPQ0PGwAZa3NVA=
Message-ID: <4B6A08C587958942AA3002690DD4F8C3010108B405@cosmail02.lsi.com>
References: <AANLkTi=praySm1B3dhU+LxhWK2yUccZkzWpd6-6UERYa@mail.gmail.com> 
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

James,

Did you get the chance to apply megaraid sas driver 2/5 to 5/5 patches?

Thanks,

Bo Yang

-----Original Message-----
From: Yang, Bo 
Sent: Tuesday, October 12, 2010 9:22 AM
To: 'bo yang'; linux-scsi@vger.kernel.org; akpm@osdl.org; linux-kernel@vger.kernel.org; James.Bottomley@suse.de
Subject: [PATCH 5/5] scsi: megaraid_sas - Version and documentation update

Re-Submit:

Update the version and documentation.

Signed-off-by Bo Yang<bo.yang@lsi.com>

---
 Documentation/scsi/ChangeLog.megaraid_sas |   47 ++++++++++++++++++++++++++++++
 drivers/scsi/megaraid/megaraid_sas.c      |    2 -
 drivers/scsi/megaraid/megaraid_sas.h      |    6 +--
 3 files changed, 51 insertions(+), 4 deletions(-)
