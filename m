Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752255Ab1AMGRU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 01:17:20 -0500
Received: from smtp.nokia.com ([147.243.1.48]:32236 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750912Ab1AMGRR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 01:17:17 -0500
From: <deepak.kodihalli@nokia.com>
To: <linux-kernel@vger.kernel.org>
Subject: Question about tty layer
Thread-Topic: Question about tty layer
Thread-Index: Acuy6XDkOSaVkS2OSlG+xdpEVtMM7A==
Date: Thu, 13 Jan 2011 06:16:40 +0000
Message-ID: <CFCD2552B303EB4C99229AB4A7875CF901429DE1@008-AM1MPN1-021.mgdnok.nokia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 13 Jan 2011 06:16:43.0631 (UTC) FILETIME=[72FA1FF0:01CBB2E9]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Does the tty layer buffer requests from the host if the tty has not been opened?

Supposing I'm working with an interface on /dev/ttyGS1. If the user space has not opened this yet, but USB is connected, would this allow the host to send data packets to this interface? If yes, and if user space opens ttyGS1 at a later stage and say adds a GIO watch on it for POLLIN, would user space receive that pollin?

Thanks,
Deepak
