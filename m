Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756560Ab0FHU4s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 16:56:48 -0400
Received: from snt0-omc1-s37.snt0.hotmail.com ([65.55.90.48]:22482 "EHLO
	snt0-omc1-s37.snt0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756536Ab0FHU4q convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 16:56:46 -0400
Message-ID: <SNT125-W593A227B1D8643303EE24DC3D60@phx.gbl>
X-Originating-IP: [164.116.126.146]
From: Yuhong Bao <yuhongbao_386@hotmail.com>
To: <alan@linux.intel.com>, <ebiederm@xmission.com>
CC: <jacob.jun.pan@linux.intel.com>, <arjan@linux.intel.com>,
       <linux-kernel@vger.kernel.org>, <hpa@zytor.com>, <mingo@elte.hu>,
       <feng.tang@intel.com>, <len.brown@intel.com>
Subject: RE: [PATCH] x86/sfi: fix ioapic gsi range
Date: Tue, 8 Jun 2010 13:56:46 -0700
Importance: Normal
In-Reply-To: <20100608201258.6c813085@linux.intel.com>
References: <1275952044-27996-1-git-send-email-jacob.jun.pan@linux.intel.com>
 <m1631ue5ho.fsf@fess.ebiederm.org> <20100607225010.342e2fab@jacob-laptop>
 <m1631tfh1i.fsf@fess.ebiederm.org>,<20100608201258.6c813085@linux.intel.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 08 Jun 2010 20:56:46.0872 (UTC) FILETIME=[1BB20980:01CB074D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> IRQ 14/15 is wrong for ATA today as its AHCI based on modern boxes
Not to mention even before that there was native mode IDE!In fact, XP SP1 and later support switching to native mode IDE on BIOSes supporting it as described in this document:http://www.microsoft.com/whdc/device/storage/Native-modeATA.mspx
Yuhong Bao 		 	   		  
_________________________________________________________________
The New Busy is not the too busy. Combine all your e-mail accounts with Hotmail.
http://www.windowslive.com/campaign/thenewbusy?tile=multiaccount&ocid=PID28326::T:WLMTAGL:ON:WL:en-US:WM_HMP:042010_4