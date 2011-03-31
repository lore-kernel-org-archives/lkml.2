Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964898Ab1CaLc0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 07:32:26 -0400
Received: from mms2.broadcom.com ([216.31.210.18]:1498 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964839Ab1CaLcY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 07:32:24 -0400
X-Server-Uuid: D3C04415-6FA8-4F2C-93C1-920E106A2031
Subject: Re: [PATCH 0/1] new module for amba axi on-chip interconnect
Date: Thu, 31 Mar 2011 13:32:08 +0200
To: "Greg KH" <greg@kroah.com>
cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk,
        =?utf-8?Q?Michael_B=C3=BCsch?= <mb@bu3sch.de>,
        "Jonas Gorski" <jonas.gorski@gmail.com>, arend@broadcom.com
MIME-Version: 1.0
From: "Arend van Spriel" <arend@broadcom.com>
Organization: Broadcom
Message-ID: <op.vs7gzu193ri7v4@arend-laptop>
User-Agent: Opera Mail/11.01 (Linux)
X-WSS-ID: 618AB9693CK9000362-01-01
Content-Type: text/plain;
 charset=utf-8;
 format=flowed;
 delsp=yes
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 29, 2011 at 06:14:53 -0700, Greg KH wrote:
> I thought this was going under drivers/staging/  What changed your mind?
> What other drivers are going to use this, I thought the current broadcom
> drivers in drivers/net/wireless were not going to need this.

Last time you asked me whether it was necessary to have this in staging.  
For this module I (think I) followed the kernel coding style and tried to  
cover most of the SubmitChecklist (if applicable). If I should reconsider  
that is fine by me.

The request for supporting amba axi scanning was raised by Jonas Gorski on  
Mon 17 Jan 2011 "Merging SSB and HND/AI support" on linux-wireless list.  
He was looking for this in the context of SoC router chips offering core  
discovery by so-called DMP plugin which ARM provides for SoC's using the  
AMBA AXI interconnect.

Gr. AvS
-- 
"The most merciful thing in the world, I think, is the inability of the  
human
mind to correlate all its contents." - "The Call of Cthulhu"

