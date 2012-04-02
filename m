Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753780Ab2DBRWx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 13:22:53 -0400
Received: from 90-46-11-204.rar.beartech.net ([204.11.46.90]:17850 "EHLO
	exchsrvr.taosinc.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753659Ab2DBRWw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 13:22:52 -0400
x-mimeole: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: TAOS Color sensor
Date: Mon, 2 Apr 2012 12:28:39 -0500
Message-ID: <B4B07CCC7B7A084E989CF9386538EA1D0120B2C6@exchsrvr.taosinc.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: TAOS Color sensor
Thread-Index: Ac0Q9gs2z27vTg6ITRGLhQw8tfzPCw==
From: "Jon Brenner" <jbrenner@TAOSinc.com>
To: <jic23@kernel.org>
Cc: <linux-iio@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a need to release a driver for the TAOS tsl3x7x family of COLOR
sensors.
The driver provides Lux (clear and IR) , Proximity, Color temperature
(calculated CCT) and raw - red, green, and blue data channels.
Currently I do not think the IIO subsystem provides for CT or RGB data
channels.
Is this correct?
What can be done to accommodate it and who can do it?

Any help is greatly appreciated!

Jon
