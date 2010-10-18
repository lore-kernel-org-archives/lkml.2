Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757878Ab0JRXXN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 19:23:13 -0400
Received: from snt0-omc2-s28.snt0.hotmail.com ([65.55.90.103]:23748 "EHLO
	snt0-omc2-s28.snt0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755064Ab0JRXXM convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 19:23:12 -0400
Message-ID: <SNT125-W625921DC185E1471AA98C1C35A0@phx.gbl>
X-Originating-IP: [96.253.143.208]
From: Yuhong Bao <yuhongbao_386@hotmail.com>
To: <hpa@zytor.com>, <jbeulich@novell.com>
CC: <linux-kernel@vger.kernel.org>, <colin.king@canonical.com>
Subject: RE: patch disabling use of PSE on Atom CPUs with a certain erratum
Date: Mon, 18 Oct 2010 16:23:12 -0700
Importance: Normal
In-Reply-To: <4CADE80E.8050905@zytor.com>
References: <4CADAB3A020000780001B30A@vpn.id2.novell.com>
 <4CADCF23.5070800@zytor.com> <4CADEED9020000780001B44F@vpn.id2.novell.com>
 <4CADD442.4050706@zytor.com> <4CADFAE6020000780001B4DC@vpn.id2.novell.com>
 <4CADE2F3.8000908@zytor.com>
 <4CAE0373020000780001B50E@vpn,<4CADE80E.8050905@zytor.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 18 Oct 2010 23:23:12.0262 (UTC) FILETIME=[6EB92A60:01CB6F1B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Well, keep in mind that the right thing really is to get the microcode
> update into the CPU early... i.e. in the BIOS, or in a pinch, from the
> bootloader -- but before the kernel runs.

So which vendors have released BIOS updates?
Good thing 64-bit was limited to the desktop Atoms in this generation.

Yuhong Bao
 		 	   		  