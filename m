Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755952Ab1AaTrK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 14:47:10 -0500
Received: from mvp.visionpro.com ([63.91.95.19]:35799 "EHLO
	extern.visionpro.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753746Ab1AaTrI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 14:47:08 -0500
X-Greylist: delayed 471 seconds by postgrey-1.27 at vger.kernel.org; Mon, 31 Jan 2011 14:47:08 EST
User-Agent: Microsoft-Entourage/12.28.0.101117
Date: Mon, 31 Jan 2011 11:39:13 -0800
Subject: Ioctl
From: "Brian D. McGrew" <brian@visionpro.com>
To: <linux-kernel@vger.kernel.org>
Message-ID: <C96C4FE1.46AA1%brian@visionpro.com>
Thread-Topic: Ioctl
Thread-Index: AcvBfomsSEJRunzbkkmpN1Zw99Lq1g==
Mime-version: 1.0
Content-type: text/plain;
	charset="US-ASCII"
Content-transfer-encoding: 7bit
X-OriginalArrivalTime: 31 Jan 2011 19:39:13.0752 (UTC) FILETIME=[8A1F0580:01CBC17E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I'm very new at working with the kernel and device drivers and I'm trying to
bring ours drivers up from a 2.6.16 kernel to 2.6.37.  I'm noticing that
ioctl() doesn't seem to be raound anymore, or at least I can't find it.

There is tons of stuff in my code that I don't yet understand which requires
the ioctl function.  What is the best way for me to either get the ioctl
working in 2.6.37, or the quickest way to work around it???

Thanks,

-b

