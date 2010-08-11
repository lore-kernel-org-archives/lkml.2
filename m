Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755728Ab0HKSv2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 14:51:28 -0400
Received: from mail.logicpd.com ([66.162.60.3]:1966 "EHLO smtp.logicpd.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755482Ab0HKSv1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 14:51:27 -0400
Content-class: urn:content-classes:message
Subject: RE: [PATCH 1/4] initial support for LogicPD's OMAP3 SOM and TORPEDO development kits
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Date: Wed, 11 Aug 2010 13:51:22 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Message-ID: <77A0A4DB5BF2A44283E5522C27234AC6021C82CB@EDPRSRV011.logicpd.com>
In-Reply-To: <20100811184922.GB21778@nokia.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 1/4] initial support for LogicPD's OMAP3 SOM and TORPEDO development kits
Thread-Index: Acs5hfDHSrI0Nkm/QnqTqZdr+AwzmwAADbWg
From: "Jacob Tanenbaum" <Jacob.Tanenbaum@logicpd.com>
To: <felipe.balbi@nokia.com>
Cc: <linux@arm.linux.org.uk>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <rmk@arm.linux.org.uk>,
        <tony@atomide.com>
X-OriginalArrivalTime: 11 Aug 2010 18:51:26.0147 (UTC) FILETIME=[336E7930:01CB3986]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Valid point we will remove the ifdefs

-----Original Message-----
From: Felipe Balbi [mailto:felipe.balbi@nokia.com] 
Sent: Wednesday, August 11, 2010 2:49 PM
To: Jacob Tanenbaum
Cc: Balbi Felipe (Nokia-MS/Helsinki); linux@arm.linux.org.uk;
linux-omap@vger.kernel.org; linux-kernel@vger.kernel.org;
rmk@arm.linux.org.uk; tony@atomide.com
Subject: Re: [PATCH 1/4] initial support for LogicPD's OMAP3 SOM and
TORPEDO development kits

Hi,

On Wed, Aug 11, 2010 at 08:45:22PM +0200, ext Jacob Tanenbaum wrote:
>No one else uses the ifdef but we were told from an earlier submission
>we should because if both boards are disabled in the .config it would
>inform the user on bootup

What do you mean ? If these boards are't enabled on .config then this 
board-file won't even get added to the binary so those machine ids won't

be available, right ?

-- 
balbi

DefectiveByDesign.org
