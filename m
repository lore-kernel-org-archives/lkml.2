Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759225Ab2EWKMH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 06:12:07 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:47685 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751409Ab2EWKME (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 06:12:04 -0400
MIME-Version: 1.0
Date: Wed, 23 May 2012 15:42:03 +0530
Message-ID: <CAHdPZaPiiXzj2+oeHRa1KrGVrESfxpxpiXOkNPyKWd-oQCbszg@mail.gmail.com>
Subject: question about the failure of eisa_root_register in drivers/eisa/pci_eisa.c
From: "devendra.aaru" <devendra.aaru@gmail.com>
To: Arnaud Lacombe <lacombar@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello ,

   If the eisa_root_register fails, the function just returns rather
than calling the pci_disable_device and return. so we need to use the
pci_disable_device and return.


Please suggest me if i am wrong.

Thanks,
Devendra.
