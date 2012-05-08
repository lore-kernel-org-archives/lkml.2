Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757008Ab2EHVx7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 17:53:59 -0400
Received: from mga14.intel.com ([143.182.124.37]:32907 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751589Ab2EHVx6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 17:53:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="97832999"
From: "Moore, Robert" <robert.moore@intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <lenb@kernel.org>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "Lin, Ming M" <ming.m.lin@intel.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "x86@kernel.org" <x86@kernel.org>
Subject: RE: [PATCH] gts and bfs fixes (v3).
Thread-Topic: [PATCH] gts and bfs fixes (v3).
Thread-Index: AQHNLORFPsGir/B0EkOqd31SK+0Pk5bA4XOA//+OoWA=
Date: Tue, 8 May 2012 21:53:52 +0000
Message-ID: <94F2FBAB4432B54E8AACC7DFDE6C92E346AC202F@ORSMSX101.amr.corp.intel.com>
References: <1334687359-9970-1-git-send-email-konrad.wilk@oracle.com>
 <4FA8BDD1.6050608@kernel.org> <201205082338.45997.rjw@sisk.pl>
In-Reply-To: <201205082338.45997.rjw@sisk.pl>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.139]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I opened a problem report against the spec about a month ago on this subject -- to remove _GTS and _BFS from the ACPI spec.

bob

> -----Original Message-----
> From: linux-acpi-owner@vger.kernel.org [mailto:linux-acpi-
> owner@vger.kernel.org] On Behalf Of Rafael J. Wysocki
> Sent: Tuesday, May 08, 2012 2:39 PM
> To: Len Brown
> Cc: Konrad Rzeszutek Wilk; linux-kernel@vger.kernel.org; linux-
> acpi@vger.kernel.org; Lin, Ming M; hpa@zytor.com; x86@kernel.org
> Subject: Re: [PATCH] gts and bfs fixes (v3).
> 
> On Tuesday, May 08, 2012, Len Brown wrote:
> > Ugh.
> >
> > I think instead we should go the other way and simply delete the code
> > for _GTS and _BFS support.
> >
> > The evidence is that while it is documented in the ACPI spec, no OS
> > implements it -- for when we tried it, we found some systems that
> > shipped AML that doesn't work.
> 
> Well, we can still remove it ...
> 
> > ps. yes, we should also petition the ACPI authors to remove _GTS and
> > _BFS from an upcoming revision.
> 
> Oh, yes, I totally agree. :-)
> 
> Thanks,
> Rafael
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi"
> in the body of a message to majordomo@vger.kernel.org More majordomo
> info at  http://vger.kernel.org/majordomo-info.html
