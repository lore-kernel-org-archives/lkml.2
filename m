Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754101Ab1BGPm4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 10:42:56 -0500
Received: from g6t0186.atlanta.hp.com ([15.193.32.63]:12675 "EHLO
	g6t0186.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752428Ab1BGPmz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 10:42:55 -0500
X-Greylist: delayed 496 seconds by postgrey-1.27 at vger.kernel.org; Mon, 07 Feb 2011 10:42:55 EST
From: "Haefliger, Juerg" <Juerg.Haefliger@hp.com>
To: "vgoyal@redhat.com" <vgoyal@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Date: Mon, 7 Feb 2011 15:33:38 +0000
Subject: Block IO throttling disabled in distros
Thread-Topic: Block IO throttling disabled in distros
Thread-Index: AcvG3GPYzq6r1tPPQBCysfqUZ/+r/g==
Message-ID: <59DD1BA8FD3C0F4C90771C18F2B5B53A653FF7284B@GVW0432EXB.americas.hpqcorp.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Both RHEL6 and Ubuntu 10.10 have block IO throttling disabled in their kernels. Does anybody know why that is? Are there performance or stability issues with the throttling controller or does it somehow negatively interfere with the rest of the kernel and/or system?

Thanks
...Juerg

