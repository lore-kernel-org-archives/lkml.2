Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755990Ab0GCVCx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jul 2010 17:02:53 -0400
Received: from mail1-out1.atlantis.sk ([80.94.52.55]:55701 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755813Ab0GCVCv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jul 2010 17:02:51 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: Jacek Poplawski <jacekpoplawski@gmail.com>
Subject: Re: SH-D163C
Date: Sat, 3 Jul 2010 23:02:40 +0200
User-Agent: KMail/1.9.10
Cc: linux-kernel@vger.kernel.org
References: <AANLkTinZfXXALWmmVPMHe-iJehQif7KC4tQCDdGge6g4@mail.gmail.com>
In-Reply-To: <AANLkTinZfXXALWmmVPMHe-iJehQif7KC4tQCDdGge6g4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <201007032302.41796.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 03 July 2010 20:07:46 Jacek Poplawski wrote:
> Hello,
>
> I bought new DVD burner and looks like I can't burn anything, because
> media is not recognized as burner.
>
> In logs I see:
> ata5.00: ATAPI: TSSTcorpDVD-ROM SH-D163C, SB00, max UDMA/100
> scsi 4:0:0:0: CD-ROM            TSSTcorp DVD-ROM SH-D163C SB00 PQ: 0 ANSI:
> 5
>
> Is this burner supported by kernel?
> If not, could you give me any hints how to add it at source code
> level? I assume it's a matter of adding new ID to some list? :)

The problem is that it really is a DVD-ROM:
http://www.google.com/search?q=%22SH-D163C%22+site%3Asamsung.com


-- 
Ondrej Zary
