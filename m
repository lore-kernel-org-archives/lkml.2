Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751650Ab0IIDnT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 23:43:19 -0400
Received: from web32402.mail.mud.yahoo.com ([68.142.207.195]:38394 "HELO
	web32402.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751152Ab0IIDnP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 23:43:15 -0400
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Wed, 08 Sep 2010 23:43:14 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:MIME-Version:Content-Type;
  b=WbNuFe4Pvlx7+T8dg0pYb+WCh0QK4zWAYRTuBWP0drbZ4+uRwc2zSsUy0gyi3M+b3JixnU910T8iY5PuON4jgtadeSQ8/4ZQ8TvtvLyOd0LfT2+XLNmYzYvEiGpnSruFMHcfmpnFXxlpiA44Xu0IwP94tibiQNs5C5Ckqkyuy1o=;
Message-ID: <35352.83946.qm@web32402.mail.mud.yahoo.com>
X-YMail-OSG: fcPf6NgVM1k29HCNCO89t5CO5.gtD4r6YoZjJikVx7ZmAhj
 HPgaH3Kd6pfuv5BA.ePsNpDJm8_OE9qbsMZxabcinEWaZmQrnx4mWhsLO1eE
 Mx.7yhcgCO6PKm.0yn8R4KlY3KTYm1_AHL_FvNS5UuGTM8.fc7Uyhi5etmKB
 5BBFC12urpJK4B3MH5x4RJJ1Ba5Sshlu3V2eeGKb9SNm.ih.arGzm6otUIGt
 iP60adKsbM5ekfRoxarGp5CEAh8HsHU2LNFn.XKDWEkMCDDsgj0FMZ6pUfwV
 r4mfIpLMs1wQkXRlwbkAW5k7XuSnASj6bS8E-
X-Mailer: YahooMailClassic/11.4.7 YahooMailWebService/0.8.105.279950
Date: Wed, 8 Sep 2010 20:36:32 -0700 (PDT)
From: Anil kumar <anils_r@yahoo.com>
Subject: scsi_cmnd data_buffer checksum
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I am writing a checksum calculation of scsi_cmnd data buffer in the driver. 

I calculate the checksum of the scsi_cmd data buffer(request_buffer) in driver queuecommand.

Now when the command is completed from the hardware and before driver sends it back to mid-layer, I calculate the checksum again of the same scsi_cmd data_buffer again.

Sometimes the checksums don't match. I mean somehow looks like OS changed the scsi_cmd data_buffer(request_buffer) in the meantime when driver is working on the command.
I print the address of the scsi_cmd data_buffer (virtual address) and its same and the contents of the buffer is also same during both the calculations.
 
Can this happen?



      
