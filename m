Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754966Ab1DVLA6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 07:00:58 -0400
Received: from mhqmail.moxa.com ([59.124.42.180]:47002 "EHLO
	mhqmail01.moxa.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754474Ab1DVLA5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 07:00:57 -0400
X-Greylist: delayed 964 seconds by postgrey-1.27 at vger.kernel.org; Fri, 22 Apr 2011 07:00:57 EDT
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="BIG5"
Content-Transfer-Encoding: 8BIT
Subject: [[PATCH 0/2] misc: add support to MOXA V2100 serial io driver
Date: Fri, 22 Apr 2011 18:20:12 +0800
Message-ID: <ECB3782BB8F03341905DD923270296115D5A23@mhqms01.moxa.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [[PATCH 0/2] misc: add support to MOXA V2100 serial io driver
thread-index: AcwA0y++eDmjYMfeS5uFGN/WQ83uQQAAETrgAAA4trAAABnAcAAAY5JQAAAc5NA=
From: =?BIG5?B?SmltbXkgQ2hlbiAos6+lw7lGKQ==?= <jimmy.chen@moxa.com>
To: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 22 Apr 2011 10:20:13.0359 (UTC) FILETIME=[DDF2F3F0:01CC00D6]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

moxa_serial_io driver support on MOXA V2100 platform to switch different serial mode, such as rs232/rs422/rs485.

Signed-off-by: Jimmy Chen <jimmy.chen@moxa.com>
---
