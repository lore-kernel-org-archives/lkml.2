Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758912Ab0FVO2X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 10:28:23 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:39124 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751897Ab0FVO2U convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 10:28:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=PvnTb1AMNtJPen4Pto4UtB3C7nlksyDX8Zd5PtpwnFWQu9vfZC7srV+bYPNDtmNWiq
         RjRy6Xb1OqODjdluXBqRZCaxQRmWlAGFxxPihAf3PSd35X0SwovJsada4nyE4kjJJYcm
         OshBX1i7xIDkFrLL2WkLJ4F9YT3pDOFNC02+U=
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Subject: Re: 2.6.35-rc3 regression: IBM Maia system is unbootable [ACPI related?]
Date: Tue, 22 Jun 2010 16:28:13 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.35-rc3; KDE/4.4.4; i686; ; )
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org
References: <1277136189.10998.63.camel@mulgrave.site>
In-Reply-To: <1277136189.10998.63.camel@mulgrave.site>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201006221628.14038.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On poniedziałek, 21 czerwca 2010 o 18:03:09 James Bottomley wrote:
> The system in question has a set of root bridges, with the CD rom (which
> is seen) being on bus 0 and the SCSI controller, which doesn't show up
> being on bus 1 (with several other things on busses > 1).
> 
> The system uses ACPI to detect the multiple bridges, so it seems that
> this failure in 2.6.35-rc3:
> 
> ACPI: Core revision 20100428
> ACPI Error: Hardware did not enter ACPI mode (20100428/evxfevnt-103)
> ACPI Warning: AcpiEnable failed (20100428/utxface-147)
> ACPI: Unable to enable ACPI
> 
> Means that we can't detect any PCI bus other than 0 and thus the system
> won't boot.
> 
> The full dmesgs for a successful (2.6.34) and failed (2.6.35-rc3) boot
> are below.
> 
> James

I created a Bugzilla entry at 
https://bugzilla.kernel.org/show_bug.cgi?id=16271
for your bug report, please add your address to the CC list in there, thanks!

-- 
Maciej Rutecki
http://www.maciek.unixy.pl
