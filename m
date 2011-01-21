Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753940Ab1AUPbo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 10:31:44 -0500
Received: from smtp.nokia.com ([147.243.1.48]:40358 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753537Ab1AUPbn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 10:31:43 -0500
Date: Fri, 21 Jan 2011 17:30:43 +0200 (EET)
From: Aaro Koskinen <aaro.koskinen@nokia.com>
X-X-Sender: aakoskin@esdhcp041196.research.nokia.com
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.38-rc1
In-Reply-To: <20110119214040.09794c7a@lxorguk.ukuu.org.uk>
Message-ID: <alpine.DEB.1.10.1101211725240.8142@esdhcp041196.research.nokia.com>
References: <AANLkTimajU0x1v6y3rH2+jr-bZ=tNLs1S_agXdGGAa3S@mail.gmail.com> <20110119214040.09794c7a@lxorguk.ukuu.org.uk>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, 19 Jan 2011, Alan Cox wrote:
> Only oddity is the kmemleak report is reporting a few possible leaks and
> suggesting I look in the sysfs file .. which isn't there ???

It's a debugfs file; the log assumes you have debugfs mounted at
/sys/kernel/debug/.

A.
