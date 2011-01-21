Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753231Ab1AUVKA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 16:10:00 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:54771 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751701Ab1AUVJ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 16:09:59 -0500
Date: Fri, 21 Jan 2011 22:09:49 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Lu, Hongjiu" <hongjiu.lu@intel.com>
Cc: "Anvin, H Peter" <h.peter.anvin@intel.com>,
        "Li, Shaohua" <shaohua.li@intel.com>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Sam Ravnborg <sam@ravnborg.org>
Subject: Re: Linux 2.6.38-rc1 doesn't boot
Message-ID: <20110121210949.GA22743@elte.hu>
References: <20110119074902.GA1670@gentoo.trippels.de>
 <1295424766.1949.879.camel@sli10-conroe>
 <4D36A759.60704@intel.com>
 <20110119090904.GA4927@elte.hu>
 <1295489286.1949.882.camel@sli10-conroe>
 <20110120112541.GA23661@elte.hu>
 <ADDEBCD9C145E542A8688C29F1FBDCB9C915F59E@orsmsx502.amr.corp.intel.com>
 <1295594339.1949.936.camel@sli10-conroe>
 <4D39A621.7080007@intel.com>
 <9DA5872FEF993D41B7173F58FCF6BE9409F70604@orsmsx504.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9DA5872FEF993D41B7173F58FCF6BE9409F70604@orsmsx504.amr.corp.intel.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Lu, Hongjiu <hongjiu.lu@intel.com> wrote:

> Or we can just ban those broken linker versions.

And not build the kernel on widely released distributions? I'm not sure that's 
acceptable.

Thanks,

	Ingo
