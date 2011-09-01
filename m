Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757315Ab1IAL6L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 07:58:11 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:46548 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753055Ab1IAL6I convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 07:58:08 -0400
From: "Nori, Sekhar" <nsekhar@ti.com>
To: Thomas Meyer <thomas@m3y3r.de>, Russell King <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>
Date: Thu, 1 Sep 2011 17:27:28 +0530
Subject: RE: [PATCH] arm: mach-davinci: use kzalloc()
Thread-Topic: [PATCH] arm: mach-davinci: use kzalloc()
Thread-Index: AcxUK8dy58oEnBNyQzC1Q+vj+nVjugUce/Bg
Message-ID: <B85A65D85D7EB246BE421B3FB0FBB5930257268CA8@dbde02.ent.ti.com>
References: <1312629976.5589.128.camel@localhost.localdomain>
In-Reply-To: <1312629976.5589.128.camel@localhost.localdomain>
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

On Sat, Aug 06, 2011 at 16:56:13, Thomas Meyer wrote:
> From: Thomas Meyer <thomas@m3y3r.de>
> 
>  Use kzalloc rather than kmalloc followed by memset with 0

Queuing this for v3.2. While applying, I changed the
subject to:

"ARM: davinci: edma: use kzalloc()"

to be more consistent with other patch headlines.

Thanks,
Sekhar

