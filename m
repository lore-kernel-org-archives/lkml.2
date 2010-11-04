Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751351Ab0KDNAg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 09:00:36 -0400
Received: from smtp.nokia.com ([147.243.1.48]:48939 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751176Ab0KDNAe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 09:00:34 -0400
From: "Matti J. Aaltonen" <matti.j.aaltonen@nokia.com>
To: linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org, akpm@kernel.org
Cc: "Matti J. Aaltonen" <matti.j.aaltonen@nokia.com>
Subject: [PATCH v3 0/1] PN544 NFC driver.
Date: Thu,  4 Nov 2010 14:57:52 +0200
Message-Id: <1288875473-22252-1-git-send-email-matti.j.aaltonen@nokia.com>
X-Mailer: git-send-email 1.6.1.3
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Mon, 2010-11-01 at 11:00 -0700, ext Randy Dunlap wrote:
> Use %zd to print ssize_t variables and %zu to print size_t:
> 
> drivers/nfc/pn544.c:332: warning: format '%d' expects type 'int',
> but argument 6 has type 'size_t'
> drivers/nfc/pn544.c:442: warning: format '%d' expects type 'int',
> but argument 6 has type 'size_t'

Fixed.

On Fri, 2010-10-29 at 14:35 -0700, ext Andrew Morton wrote:
On Fri, 29 Oct 2010 09:26:09 +0300
> "Matti J. Aaltonen" <matti.j.aaltonen@nokia.com> wrote:
> 
> > +static void __exit pn544_exit(void)
> > +{
> > +	flush_scheduled_work();
> 
> You said this had been removed.  Did you send the correct version?

Now I've removed it.

I've also replaced short msleeps with usleep_range calls. And in addition
I rewrote the document file.

B.R.
Matti 






 

Matti J. Aaltonen (1):
  NFC: Driver for NXP Semiconductors PN544 NFC chip.

 Documentation/nfc/nfc-pn544.txt |  117 +++++
 drivers/Kconfig                 |    2 +
 drivers/Makefile                |    2 +-
 drivers/nfc/Kconfig             |   30 ++
 drivers/nfc/Makefile            |    5 +
 drivers/nfc/pn544.c             |  891 +++++++++++++++++++++++++++++++++++++++
 include/linux/nfc/pn544.h       |   97 +++++
 7 files changed, 1143 insertions(+), 1 deletions(-)
 create mode 100644 Documentation/nfc/nfc-pn544.txt
 create mode 100644 drivers/nfc/Kconfig
 create mode 100644 drivers/nfc/Makefile
 create mode 100644 drivers/nfc/pn544.c
 create mode 100644 include/linux/nfc/pn544.h

