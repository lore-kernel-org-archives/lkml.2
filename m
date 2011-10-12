Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752360Ab1JLC7U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 22:59:20 -0400
Received: from tn-76-7-162-101.sta.embarqhsd.net ([76.7.162.101]:57871 "EHLO
	animx.eu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751796Ab1JLC7U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 22:59:20 -0400
Date: Tue, 11 Oct 2011 22:59:18 -0400
From: Wakko Warner <wakko@animx.eu.org>
To: linux-kernel@vger.kernel.org
Subject: Re: Slow write performance with mpt2sas
Message-ID: <20111012025918.GA16695@animx.eu.org>
Mail-Followup-To: linux-kernel@vger.kernel.org
References: <20111012002556.GA32495@animx.eu.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111012002556.GA32495@animx.eu.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wakko Warner wrote:
> I've noticed that my SAS9212-4i4e is having write issues.  I have a raid5 of
> 4 2tb seagate green drives and a raid5 of 3 300gb seagate 15k sas drives. 
> Write performance on the green drives is fairly poor.  The riad4 of 4 disks
> has a write performance of about 6-10mb/sec.  My onboard sas controller
> (1068e chip IT mode) does not have this issue (I'm using raid6 on 8 of the
> same model green drives).
> 
> Write performance on the 15k drives in raid 5 was 140mb/sec (4gb volume).

Sorry, this appears to be a KVM issue.  I had forgotten that I was using
this under KVM.  Adding cache=writeback fixed my problems (Also note, my
load before this went to >35 when writing, now it's no higher than about 9)
