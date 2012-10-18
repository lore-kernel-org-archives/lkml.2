Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932191Ab2JRQRF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 12:17:05 -0400
Received: from mail.skyhub.de ([78.46.96.112]:40508 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753324Ab2JRQRA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 12:17:00 -0400
Date: Thu, 18 Oct 2012 18:17:00 +0200
From: Borislav Petkov <bp@alien8.de>
To: Dan Magenheimer <dan.magenheimer@oracle.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Konrad Wilk <konrad.wilk@oracle.com>,
        linux-acpi@vger.kernel.org, x86@kernel.org,
        xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org,
        lenb@kernel.org
Subject: Re: [Xen-devel] Is: axe read_tscp pvops call. Was: Re: [RFC] ACPI S3
 and Xen (suprisingly small\!).
Message-ID: <20121018161659.GA20354@x1.osrc.amd.com>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Dan Magenheimer <dan.magenheimer@oracle.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Konrad Wilk <konrad.wilk@oracle.com>, linux-acpi@vger.kernel.org,
	x86@kernel.org, xen-devel@lists.xensource.com,
	linux-kernel@vger.kernel.org, lenb@kernel.org
References: <1350481786-4969-1-git-send-email-konrad.wilk@oracle.com>
 <507ED6C0.4020503@zytor.com>
 <20121017161036.GA10691@phenom.dumpdata.com>
 <507EE1C3.7070300@zytor.com>
 <20121017165452.GA22740@phenom.dumpdata.com>
 <507EEC53.1010309@zytor.com>
 <84b3cbf9-7c84-4d7e-a2d7-46b0d1cc5975@default>
 <50802030.8070107@zytor.com>
 <dd8748de-4715-499a-8c7e-745af37fa6c4@default>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <dd8748de-4715-499a-8c7e-745af37fa6c4@default>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 18, 2012 at 08:56:40AM -0700, Dan Magenheimer wrote:
> I agree the whole idea of paravirtualization is a hack, but it is a
> hack to workaround some poor architectural design decisions many years
> ago by Intel processor designers who should have known better. Go yell
> at them.
>
> Worse, the rdtscp instruction was a poor design decision by AMD
> processor designers to hack around tsc skew problems. Go yell at them
> too.
>
> And both Intel and AMD chose to perpetuate the problem with a
> complicated VT/SVM implementation that will never perform as well as
> native. At least they tried ;-)

Looks like xen people seem to know better so maybe they should design
their own processor, add xen support for it and leave the linux kernel
alone so that both camps can finally get on with their lives.

-- 
Regards/Gruss,
Boris.
