Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754907Ab1JMPpS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 11:45:18 -0400
Received: from mx0.aculab.com ([213.249.233.131]:35419 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756111Ab1JMPpO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 11:45:14 -0400
X-Greylist: delayed 402 seconds by postgrey-1.27 at vger.kernel.org; Thu, 13 Oct 2011 11:45:14 EDT
x-mimeole: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH][v2] uio: Support 36-bit physical addresses on 32-bit systems
Date: Thu, 13 Oct 2011 16:37:20 +0100
Message-ID: <AE90C24D6B3A694183C094C60CF0A2F6D8AE7E@saturn3.aculab.com>
In-Reply-To: <4E9704F9.1090103@freescale.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
thread-topic: [PATCH][v2] uio: Support 36-bit physical addresses on 32-bit systems
thread-index: AcyJvYTr5wYIPcZWSE26IPf+DU8W6wAAECwA
From: "David Laight" <David.Laight@ACULAB.COM>
To: "Timur Tabi" <timur@freescale.com>,
        "Kumar Gala" <galak@kernel.crashing.org>
Cc: <linuxppc-dev@ozlabs.org>, <hjk@hansjkoch.de>, <gregkh@suse.de>,
        <linux-kernel@vger.kernel.org>,
        "Jiang Kai-B18973" <B18973@freescale.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 
> Kumar Gala wrote:
> >>> >> +       phys_addr_t             addr;
> >> > 
> >> > Please add a comment here saying:
> >> > 
> >> > 1) That 'addr' can be a virtual or physical address
> > The code and everything else makes that clear
> 
> I'm sorry, but I have to strongly disagree here.  It is *NOT* 
> clear that a variable of type 'phys_addr_t' can hold something
> that is not a physical address.

Since there is a discriminating field, could a union be used?
At a guess the type of the address is constrained between
produces and consumer??

	David


