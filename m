Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757253Ab2JRQot (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 12:44:49 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:35054 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753463Ab2JRQor (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 12:44:47 -0400
X-IronPort-AV: E=Sophos;i="4.80,608,1344211200"; 
   d="scan'208";a="15260778"
Date: Thu, 18 Oct 2012 17:44:22 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Borislav Petkov <bp@alien8.de>
CC: Dan Magenheimer <dan.magenheimer@oracle.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Konrad Wilk <konrad.wilk@oracle.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lenb@kernel.org" <lenb@kernel.org>
Subject: Re: [Xen-devel] Is: axe read_tscp pvops call. Was: Re: [RFC] ACPI
 S3 and Xen (suprisingly small\!).
In-Reply-To: <20121018161659.GA20354@x1.osrc.amd.com>
Message-ID: <alpine.DEB.2.02.1210181737390.2689@kaball.uk.xensource.com>
References: <1350481786-4969-1-git-send-email-konrad.wilk@oracle.com> <507ED6C0.4020503@zytor.com> <20121017161036.GA10691@phenom.dumpdata.com> <507EE1C3.7070300@zytor.com> <20121017165452.GA22740@phenom.dumpdata.com> <507EEC53.1010309@zytor.com>
 <84b3cbf9-7c84-4d7e-a2d7-46b0d1cc5975@default> <50802030.8070107@zytor.com> <dd8748de-4715-499a-8c7e-745af37fa6c4@default> <20121018161659.GA20354@x1.osrc.amd.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Oct 2012, Borislav Petkov wrote:
> On Thu, Oct 18, 2012 at 08:56:40AM -0700, Dan Magenheimer wrote:
> > I agree the whole idea of paravirtualization is a hack, but it is a
> > hack to workaround some poor architectural design decisions many years
> > ago by Intel processor designers who should have known better. Go yell
> > at them.
> >
> > Worse, the rdtscp instruction was a poor design decision by AMD
> > processor designers to hack around tsc skew problems. Go yell at them
> > too.
> >
> > And both Intel and AMD chose to perpetuate the problem with a
> > complicated VT/SVM implementation that will never perform as well as
> > native. At least they tried ;-)
> 
> Looks like xen people seem to know better so maybe they should design
> their own processor, add xen support for it and leave the linux kernel
> alone so that both camps can finally get on with their lives.

I know that it is obvious but it is worth stating it in clear letters:

these are Dan's personal opinions and by no means represent the position
of the Xen community as a whole on this topic.

I, for one, have no idea what he is talking about.
