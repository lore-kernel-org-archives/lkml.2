Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937947Ab0CPQTl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 12:19:41 -0400
Received: from sdcmail01.amcc.com ([198.137.200.72]:60215 "EHLO
	sdcmail01.amcc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937904Ab0CPQTj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 12:19:39 -0400
X-IronPort-AV: E=Sophos;i="4.49,650,1262592000"; 
   d="scan'208";a="25410422"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: Failure with the 2.6.34-rc1 kernel
Date: Tue, 16 Mar 2010 09:19:21 -0700
Message-ID: <AC311A8E81420D4EBC1F26E6479848FE065B7D5B@SDCEXCHANGE01.ad.amcc.com>
In-Reply-To: <alpine.LRH.2.00.1003161646590.26353@twin.jikos.cz>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
thread-topic: Failure with the 2.6.34-rc1 kernel
Thread-Index: AcrFIBDephghYQAWT/CuZ2gwtDYRNQAA50mA
References: <AC311A8E81420D4EBC1F26E6479848FE065B7D3D@SDCEXCHANGE01.ad.amcc.com> <alpine.LRH.2.00.1003161646590.26353@twin.jikos.cz>
From: "Rupjyoti Sarmah" <rsarmah@amcc.com>
To: "Jiri Kosina" <jkosina@suse.cz>
Cc: <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It has been failing from this commit.

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commi
t;h=ef1a8de8ea004a689b2aa9f5cefcba2b1a0262f2 .

Also, the u-boot restarts the board very quickly. It does not go to the
kernel prompt at all. 

Regards,
Rup


-----Original Message-----
From: Jiri Kosina [mailto:jkosina@suse.cz] 
Sent: Tuesday, March 16, 2010 9:18 PM
To: Rupjyoti Sarmah
Cc: linux-kernel@vger.kernel.org
Subject: Re: Failure with the 2.6.34-rc1 kernel

On Tue, 16 Mar 2010, Rupjyoti Sarmah wrote:

> We are seeing issues in booting some of our boards with this new
kernel.
> Kernel version upto 2.6.33 works fine on the boards like Canyonlands,
> Katmai, Glacier etc.
> These boards are not booting with kernel later than 2.6.33. Please let
> me know how about fixing these issues ?

You'd need to provide at least dmesg from the working and non-working 
cases.

Also git-bisect between 2.6.33 and 2.6.34-rc1 might help you identify
the 
commit that broke your hardware.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.

