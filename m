Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756393Ab0JETwk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 15:52:40 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:35040 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754470Ab0JETwi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 15:52:38 -0400
From: "Ramirez Luna, Omar" <omar.ramirez@ti.com>
To: Felipe Contreras <felipe.contreras@gmail.com>, Greg KH <greg@kroah.com>
CC: linux-omap <linux-omap@vger.kernel.org>,
        linux-main <linux-kernel@vger.kernel.org>,
        Ohad Ben-Cohen <ohad@wizery.com>, Tony Lindgren <tony@atomide.com>,
        Hiroshi Doyu <hiroshi.doyu@nokia.com>
Date: Tue, 5 Oct 2010 14:52:30 -0500
Subject: RE: [PATCH 0/2] omap: dsp: make the driver actually work
Thread-Topic: [PATCH 0/2] omap: dsp: make the driver actually work
Thread-Index: ActkwtnW+Lx6/dKrSDSRjo5iVLk/JwAA7nzw
Message-ID: <27F9C60D11D683428E133F85D2BB4A5304681D4889@dlee03.ent.ti.com>
References: <1286208555-8829-1-git-send-email-felipe.contreras@gmail.com>
	<20101005190741.GC20825@kroah.com>
 <AANLkTikOBWxXh7uVrDxfW3OnwOM58JTXU76KUUoQWBWM@mail.gmail.com>
In-Reply-To: <AANLkTikOBWxXh7uVrDxfW3OnwOM58JTXU76KUUoQWBWM@mail.gmail.com>
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

Felipe Contreras wrote:
...
> 
> Well, I thought it would be nice if the driver actually worked on
> .36, but anyway, I'll rebase the rest of my cleanup patches and send
> them. Hopefully I find a way to get rid of the ioremap() issue. 
> 

phys_to_virt instead of ioremap should work fine, still need to try it though.

Regards,

omar
