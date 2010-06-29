Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756198Ab0F2VNH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 17:13:07 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:38895 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754702Ab0F2VNE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 17:13:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=m38JZbUSxdrie9J8X2ITP/+5vaUI7kEt+MtanEaZZQ6z/x+XfNRVyGUde8eLV11siB
         dQBA8cPCjweo447iGOapp298hrlJBEOvJfSB32IvED7gqVc1viO7zTw0ZIjzGDDFWSJs
         iOa27Zyby7gN0Z0vsBtxVd8jDLE3GVNfI6T7o=
MIME-Version: 1.0
Date: Tue, 29 Jun 2010 15:13:03 -0600
Message-ID: <AANLkTingidlvRUaD4FwNDybaZ29Qrr_507Pto1vVqo-a@mail.gmail.com>
Subject: 2.6.34 Northbridge Chipset Errors on HP Proliant 4 x Opteron in 
	x86_64 mode
From: Jeffrey Merkey <jeffmerkey@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On a 4 x Opteron HP Proliant Server with a CCISS array controller in
x86_64 mode, under very heavy (saturated) disk IO, 2.6.34 reports the
following error:

Jun 29 02:02:08  kernel: Northbridge Error, node 0, core: 0
Jun 29 02:02:08  kernel: ECC/ChipKill ECC error.
Jun 29 02:02:08  kernel: EDAC amd64 MC0: CE ERROR_ADDRESS= 0xc7358280
Jun 29 02:02:08  kernel: EDAC amd64: get_channel_from_ecc_syndrome:
error reading F3x180.
Jun 29 02:02:08  kernel: EDAC MC0: CE page 0xc7358, offset 0x280,
grain 0, syndrome 0xa4c1, row 3, channel 0, label "": amd64_edac
Jun 29 02:03:21  kernel: Northbridge Error, node 0
Jun 29 02:03:21  kernel: ECC/ChipKill ECC error.
Jun 29 02:03:21  kernel: EDAC amd64 MC0: CE ERROR_ADDRESS= 0xc7358280
Jun 29 02:03:21  kernel: EDAC amd64: get_channel_from_ecc_syndrome:
error reading F3x180.
Jun 29 02:03:21  kernel: EDAC MC0: CE page 0xc7358, offset 0x280,
grain 0, syndrome 0xa4c1, row 3, channel 0, label "": amd64_edac

The error is reproduceable by subjecting the server to excessive disk
loads > 350 MB/S stream to disk.

Jeff
