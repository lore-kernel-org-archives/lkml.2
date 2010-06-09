Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757335Ab0FIJlW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 05:41:22 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:44799 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757265Ab0FIJlV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 05:41:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=Yb5NWWNuwrgIC5vO9KYESGSamRZBZvHvjAOMwDYpvgSox6XsmK3sVDqyQYdMfhLKVL
         bkNVoPACEjdD5PvyL4X/i8DTqEp4OoTBbDlpwSTXITxZlOK01kV0eLz6Pw3edSNF6fQa
         ab1wCLh4eSIs/rSzbSwsaV0fs1OwKs3wkdWzQ=
MIME-Version: 1.0
Date: Wed, 9 Jun 2010 15:11:20 +0530
Message-ID: <AANLkTinfPl-JAP_4ZzdzJf2uyWcZ_0qfRQiT16_D8Pdd@mail.gmail.com>
Subject: Ext2/3 Filesystem Analysis
From: "Yedire, Sandeep" <syedire@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

I am currently working on Ext2/3 filesystem analysis on SLC NAND Flash device.

I have added code at driver level to note the erase and write count to
each sectors at NAND flash device.

With test application doing read/write of 64MB file with a particular
pattern, I have noted below results
With Ext2:
Filesystem block at Sector 0 is being updated more frequently at ratio
of 4 to 4.5 times that of data block.
Filesystem block(super block copies) are being updated at twice the
frequency compared to data block.

With Ext3:
Filesystem block at Sector 0 is being updated more frequently at ratio
of 5.5 to 6 times that of data block.
Filesystem block(super block copies) are being updated at around
1.5times the frequency compared to data block.

Has anyone come across this kind of behaviour with these filesystems
on NAND Flash?
Please comment on this results.
Many thanks,
Sandeep
