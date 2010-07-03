Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755294Ab0GCSHs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jul 2010 14:07:48 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:43449 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753326Ab0GCSHr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jul 2010 14:07:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=xJSj7zSa7Dbqx3z/tpfHX2uyiI2ai3OV1acCMD0E7zXsRN3JcWBO1PBmj1Ws+nexLE
         dJGj7cRBmwDPcKUIbPgFhX239GOSYLPVx0VJFxOmcjUAbAcEEb0hZN9Ex8mcOWyek3Jl
         fW4y7ktMDlIFHr/zSCqV3bzvhCNsu6atH4Bok=
MIME-Version: 1.0
Date: Sat, 3 Jul 2010 20:07:46 +0200
Message-ID: <AANLkTinZfXXALWmmVPMHe-iJehQif7KC4tQCDdGge6g4@mail.gmail.com>
Subject: SH-D163C
From: Jacek Poplawski <jacekpoplawski@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I bought new DVD burner and looks like I can't burn anything, because
media is not recognized as burner.

In logs I see:
ata5.00: ATAPI: TSSTcorpDVD-ROM SH-D163C, SB00, max UDMA/100
scsi 4:0:0:0: CD-ROM            TSSTcorp DVD-ROM SH-D163C SB00 PQ: 0 ANSI: 5

Is this burner supported by kernel?
If not, could you give me any hints how to add it at source code
level? I assume it's a matter of adding new ID to some list? :)
