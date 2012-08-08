Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757564Ab2HHGN1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 02:13:27 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:38642 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756528Ab2HHGNZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 02:13:25 -0400
X-AuditID: cbfee61b-b7f566d000005c8a-97-5022038279c6
Date: Wed, 08 Aug 2012 08:13:17 +0200
From: Lukasz Majewski <l.majewski@samsung.com>
To: Peiyong Feng <peiyong.feng.kernel@gmail.com>
Cc: balbi@ti.com, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [BUG] Kernel panic when try s3c-hsotg.c with kernel 3.5
Message-id: <20120808081317.40c883f9@amdc308.digital.local>
In-reply-to: <CAN_1Rdu+xy9EzmHty+wT4GYUGADmNMOxk2_FcG9jJ6R2nO-iBQ@mail.gmail.com>
References: <CAN_1RdsTX5ZGSx7T6X0t70Q6k5_M1zgizL-KzPYrnHOnZ_nfSg@mail.gmail.com>
 <20120806101200.GJ17551@arwen.pp.htv.fi>
 <20120806151436.4761cd4d@amdc308.digital.local>
 <CAN_1RdsFh5-xZ7ijL-Cwf4cDzWYthFfMOM7dPdRUub2rQ_RMDw@mail.gmail.com>
 <20120807113416.57b03f4f@amdc308.digital.local>
 <CAN_1Rdu+xy9EzmHty+wT4GYUGADmNMOxk2_FcG9jJ6R2nO-iBQ@mail.gmail.com>
Organization: SPRC Poland
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrNLMWRmVeSWpSXmKPExsVy+t9jQd0mZqUAg461+haXd81hs1i0rJXZ
	gcnj8ya5AMYoLpuU1JzMstQifbsErox/s46zFlxnqvjzahtLA2MHUxcjB4eEgInEzxdeXYyc
	QKaYxIV769m6GLk4hASmM0r8uTqfFcJpZ5K4cO07G0gVi4CqxL++94wgNpuAnsTnu0+ZQGwR
	AQOJ9V+XsoPYzAKeEpd3HwarERZwkdi25BhYL6+AtUTXx0lg9ZwCwRK9ByYzQSx4zySx/FoT
	WBG/gKRE+78fzBAn2UrM/fWGBaJZUOLH5HssEAu0JDZva2KFsOUlNq95yzyBUXAWkrJZSMpm
	ISlbwMi8ilE0tSC5oDgpPddIrzgxt7g0L10vOT93EyM4SJ9J72Bc1WBxiFGAg1GJh3dTqmKA
	EGtiWXFl7iFGCQ5mJRHePQeBQrwpiZVVqUX58UWlOanFhxilOViUxHlNvL/6CwmkJ5akZqem
	FqQWwWSZODilGhjDNlSmHtEVXqBmsuPZnWKuRe/it9//d2Sh2sO7VhW1b7sca7xndzW7b2ow
	fNK96ZZ9yxz+5/2zmpynvNkfOH+m9ey/m/izzh7fZVjftuTzj3VPa3W/dC5zKLIzXfuGR+nc
	xivMNd+j51ic0ZrzTv8aYzXrlV373rUeZf6gYnSLw6g2O3LLmauflViKMxINtZiLihMBpl18
	0E4CAAA=
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Peiyong Feng,

> > Please enable the debug at s3c-hsotg.c driver and then paste the
> > dmesg/debug output.  
> I have defined DEGUG in s3c-hsotg.c

Thank you for 2.6.36 log.
I'd also need the log from 3.6-rc1 kernel with DEBUG enabled.

-- 
Best regards,

Lukasz Majewski

Samsung Poland R&D Center | Linux Platform Group
