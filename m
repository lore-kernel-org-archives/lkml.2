Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752036Ab0DDHbI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Apr 2010 03:31:08 -0400
Received: from smtp-out002.kontent.com ([81.88.40.216]:32980 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751553Ab0DDHa6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Apr 2010 03:30:58 -0400
From: Oliver Neukum <oliver@neukum.org>
To: "tek-life" <teklife.kernel@gmail.com>
Subject: Re: Can we remove the Zone_DMA?
Date: Sun, 4 Apr 2010 09:31:00 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34-rc2-0.1-default; KDE/4.3.5; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, ebiederm@xmission.com
References: <m2mc58e39921004032121hc7ca41f0gacd90ffe2abc6444@mail.gmail.com>
In-Reply-To: <m2mc58e39921004032121hc7ca41f0gacd90ffe2abc6444@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="gb2312"
Content-Transfer-Encoding: 8BIT
Message-Id: <201004040931.00634.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Sonntag, 4. April 2010 06:21:54 schrieb tek-life:
> In Linux , The Memory is divided to three zone. They are ZONE_DMA
> ¡¢ZONE_NORMAL  and ZONE_HIGHMEM. From the book of "Undstand the Linux
> kernel ", the ZONE_DMA has the effect that the Direct Memory Access
> (DMA) processors for old ISA buses have a strong limitation: they are
> able to address only the first 16 MB of RAM. SO ,we must set a zone
> for  the DMA on ISA bus.  And I suspect that the hardware has
> developed so quickly .And  in this days the ISA has been weeded out.

Floppy disks & paralell ports still use DMA

	Regards
		Oliver
