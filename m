Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758189Ab0GUVJ1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 17:09:27 -0400
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:43189 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755941Ab0GUVJ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 17:09:26 -0400
Subject: NCR53C80 datasheet is publicly available
From: Andy Walls <awalls@md.metrocast.net>
To: akpm@linux-foundation.org, James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, linux@rainbow-software.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <201007202228.o6KMSnYq021739@imap1.linux-foundation.org>
References: <201007202228.o6KMSnYq021739@imap1.linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 21 Jul 2010 17:08:50 -0400
Message-ID: <1279746530.20291.29.camel@morgan.silverblock.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.0.10011,1.0.148,0.0.0000
 definitions=2010-07-21_08:2010-07-21,2010-07-21,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 ipscore=0 phishscore=0
 bulkscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 engine=5.0.0-1005130000 definitions=main-1007210092
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To address James' concern for knowing how to program the NCR 53C80:

Halfway down this page, the first datasheet PDF, is a scan of the
NCR5380 family data sheet with register definitions, etc:

http://www.datasheetarchive.com/53C80-40-datasheet.html


The only cards I've ever seen with this chip were ISA bus cards wired to
respond to I/O space accesses.  These chips can be wired for MMIO as
it's just really a difference in the address decode logic.  (In fact
Appendix B of the datasheet shows the chip wired up to a 65C02 - an
ancient processor design that has no notion of I/O address space so its
I/O must be memory mapped.)

I can't seem to find a datasheet for the NCR53C400 or NCR53C400A.  The
NCR53C80 datasheet introduction implies the 5380 is used as a core in
the 53C400 though.  Since LSI Logic owns all of Symbios Logic's IP (NCR
sold off Symbios long ago), you may just need to ask LSI Logic if they
have a 53c400 datasheet available.

Regards,
Andy



