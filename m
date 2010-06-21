Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755830Ab0FUMYF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 08:24:05 -0400
Received: from mxout12.netvision.net.il ([194.90.6.37]:45723 "EHLO
	mxout12.netvision.net.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752995Ab0FUMYA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 08:24:00 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=us-ascii
X-MIMEOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
Subject: RE: [PATCH] HID: Add support to new N-trig firwmare
Date: Mon, 21 Jun 2010 15:24:54 +0300
Message-id: <48A28051AC6D7A48B64F2827245819033828C1@Exchange-IL.n-trig.com>
In-reply-to: <alpine.LNX.2.00.1006211342580.13809@pobox.suse.cz>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-topic: [PATCH] HID: Add support to new N-trig firwmare
Thread-index: AcsRNv7u+dKDDmCJQBidUtKDKZ1KmAABVN8w
References: <48A28051AC6D7A48B64F28272458190333674B@Exchange-IL.n-trig.com>
 <alpine.LNX.2.00.1006041115480.12271@pobox.suse.cz>
 <48A28051AC6D7A48B64F28272458190326E03E@Exchange-IL.n-trig.com>
 <alpine.LNX.2.00.1006051741361.12271@pobox.suse.cz>
 <48A28051AC6D7A48B64F28272458190338280A@Exchange-IL.n-trig.com>
 <alpine.LNX.2.00.1006211143520.13809@pobox.suse.cz>
 <48A28051AC6D7A48B64F282724581903382885@Exchange-IL.n-trig.com>
 <alpine.LNX.2.00.1006211342580.13809@pobox.suse.cz>
From: Micki Balanga <micki@n-trig.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: chatty@enac.fr, dhprince-devel@yahoo.co.uk, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, Rafi Rubin <rafi@seas.upenn.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi 
Thank you very much but the product id runs from 0x01 - 0x14(Not 0x0A)
(hid_blacklist, ntrig_devices - were updated till 0x14)
Micki

-----Original Message-----
From: Jiri Kosina [mailto:jkosina@suse.cz] 
Sent: Monday, June 21, 2010 2:44 PM
To: Micki Balanga
Cc: chatty@enac.fr; dhprince-devel@yahoo.co.uk;
linux-input@vger.kernel.org; linux-kernel@vger.kernel.org; Rafi Rubin
Subject: RE: [PATCH] HID: Add support to new N-trig firwmare

On Mon, 21 Jun 2010, Micki Balanga wrote:

> Attach one file which update hid_blacklist.
> Attach Second patch which update ntrig_devices.

I have folded the patches together, rebased them on top of the patch you

already sent me and I had in my tree (adding devices up od 0x0A), and 
applied. Thanks,

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
