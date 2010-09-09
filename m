Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756267Ab0IIAR4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 20:17:56 -0400
Received: from ironport.bytemobile.com ([12.153.136.13]:48482 "EHLO
	ironport.bytemobile.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751089Ab0IIARv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 20:17:51 -0400
X-IronPort-AV: E=Sophos;i="4.56,336,1280732400"; 
   d="scan'208";a="4085892"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Subject: how to tell if you are executing in soft IRQ context
Date: Wed, 8 Sep 2010 17:17:49 -0700
Message-ID: <6F5DE7538AFCDA45A114F5E7510424A7020CCDC0@hq-exchange01.bytemobile.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: how to tell if you are executing in soft IRQ context
Thread-Index: ActPtG+c4okp0l1WRfGrZE1SJurUYQ==
From: "Jeff Haran" <jharan@bytemobile.com>
To: <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Is there a function that can be called to determine if you are executing
in soft IRQ context in kernel version 2.6.31?

Note I've already tried in_softirq(). That doesn't work since it also
returns non-zero if you are running in process context but have disabled
bottom halves.

Thanks,

Jeff Haran

http://www.bytemobile.com/blog 

This e-mail and any attachments may contain confidential and privileged information. If you are not the intended recipient, please notify the sender immediately by return e-mail, do not forward this email to any other person, delete this e-mail and destroy all copies. Any dissemination or use of this information by a person other than the intended recipient is unauthorized and may be illegal.

