Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753191Ab0FMDxt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jun 2010 23:53:49 -0400
Received: from cnshjsmin03.alcatel-sbell.com.cn ([211.144.215.47]:48242 "EHLO
	cnshjsmin03.alcatel-sbell.com.cn" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753045Ab0FMDxs convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jun 2010 23:53:48 -0400
X-AuditID: ac189297-b7bddae000004530-a0-4c1456185864
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Subject: mq_receive failed with errno=512 (ERESTARTSYS)
Date: Sun, 13 Jun 2010 11:53:45 +0800
Message-ID: <80366F5EAAE27640A7221E6EF6AB54E5E8907D@CNSHGSMBS04.ad4.ad.alcatel.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: mq_receive failed with errno=512 (ERESTARTSYS)
Thread-Index: AcsKkcRbMbV1HuZAS8675QukyLoKaQAGilug
From: "WANG Jerry J" <Jerry.j.Wang@alcatel-lucent.com>
To: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 13 Jun 2010 03:53:46.0675 (UTC) FILETIME=[06500030:01CB0AAC]
X-CFilter-Loop: Reflected
X-Brightmail-Tracker: AAAAAQAAAZE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


In the user space, Can we see ERESTARTSYS? I assume we should see EINTR.
Am I right?
How to reproduce this case?

Thanks,
Jerry

