Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751073Ab0DDEV7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Apr 2010 00:21:59 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:56247 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750720Ab0DDEVz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Apr 2010 00:21:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:date:x-google-sender-auth:message-id:subject
         :from:to:content-type:content-transfer-encoding;
        b=MNvGtbX/YzXZtrx+1FgDtSVfab/Ees7kft+sBlEI3FI0nFPbgzRvSQlVs6TSHNhXnA
         SZ6CjgdYKquja1WL220jZp2kvRUlC26e44mbccEy7rGzB4sNpWy6qU1k7kD4uyA25oaZ
         SxKNf3bniGiKrjgruH0Kg8Cqp1VJNfNjGcPXA=
MIME-Version: 1.0
Date: Sun, 4 Apr 2010 12:21:54 +0800
X-Google-Sender-Auth: 4450130945436131
Message-ID: <m2mc58e39921004032121hc7ca41f0gacd90ffe2abc6444@mail.gmail.com>
Subject: Can we remove the Zone_DMA?
From: tek-life <teklife.kernel@gmail.com>
To: linux-kernel@vger.kernel.org, ebiederm@xmission.com
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I¡¯m a newbie on the linux kernel. Now I am reading the source code of
Linux . I have a question in the following about ZONE_DMA.


In Linux , The Memory is divided to three zone. They are ZONE_DMA
¡¢ZONE_NORMAL  and ZONE_HIGHMEM. From the book of "Undstand the Linux
kernel ", the ZONE_DMA has the effect that the Direct Memory Access
(DMA) processors for old ISA buses have a strong limitation: they are
able to address only the first 16 MB of RAM. SO ,we must set a zone
for  the DMA on ISA bus.  And I suspect that the hardware has
developed so quickly .And  in this days the ISA has been weeded out.
And so ,if we not defined the ZONE_DMA, is the system be effected? And
why not remove ZONE_DMA from the kernel . If it cann¡®t to do so£¬the
compatibility is the only reason?


Thanks
