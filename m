Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751828Ab0DFIfH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 04:35:07 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:62666 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751229Ab0DFIfD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 04:35:03 -0400
Date: Tue, 6 Apr 2010 01:35:00 -0700 (PDT)
From: Christian Kujau <lists@nerdbynature.de>
To: Wolfram Sang <w.sang@pengutronix.de>
cc: LKML <linux-kernel@vger.kernel.org>, ebiederm@xmission.com
Subject: Re: 2.6.34-rc: key ffff8801fefc0310 not in .data!
In-Reply-To: <20100406081912.GC5102@pengutronix.de>
Message-ID: <alpine.DEB.2.01.1004060133030.29272@bogon.housecafe.de>
References: <alpine.DEB.2.01.1004052344210.29272@bogon.housecafe.de> <20100406081912.GC5102@pengutronix.de>
User-Agent: Alpine 2.01 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V01U2FsdGVkX1/T2SPoWnnrdyKnJNIXHJm2W9likltJ6akgKHJ
 sVmwXOXCsViO/vnb9dfy/IWMMiGu3RVRdNqFpYi2usocz8ZYVd
 7KrhPPj0+2zdHKMB+QESg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Apr 2010 at 10:19, Wolfram Sang wrote:
> Should have been fixed by ebd09ec93c90c8ec571d7e166832fb1fc705bf5e
> (which came after -rc3).

Ah, now I see it. I've pulled on April 5, but apparently before Linus 
merged even more stuff.

Thanks,
Christian.
-- 
BOFH excuse #336:

the xy axis in the trackball is coordinated with the summer solstice
