Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932627Ab2JRRFL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 13:05:11 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46747 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932595Ab2JRRE4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 13:04:56 -0400
Message-ID: <5080369B.3080204@zytor.com>
Date: Thu, 18 Oct 2012 10:04:27 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121009 Thunderbird/16.0
MIME-Version: 1.0
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: Borislav Petkov <bp@alien8.de>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Konrad Wilk <konrad.wilk@oracle.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lenb@kernel.org" <lenb@kernel.org>
Subject: Re: [Xen-devel] Is: axe read_tscp pvops call. Was: Re: [RFC] ACPI
 S3 and Xen (suprisingly small\!).
References: <1350481786-4969-1-git-send-email-konrad.wilk@oracle.com> <507ED6C0.4020503@zytor.com> <20121017161036.GA10691@phenom.dumpdata.com> <507EE1C3.7070300@zytor.com> <20121017165452.GA22740@phenom.dumpdata.com> <507EEC53.1010309@zytor.com> <84b3cbf9-7c84-4d7e-a2d7-46b0d1cc5975@default> <50802030.8070107@zytor.com> <dd8748de-4715-499a-8c7e-745af37fa6c4@default> <20121018161659.GA20354@x1.osrc.amd.com> <alpine.DEB.2.02.1210181737390.2689@kaball.uk.xensource.com>
In-Reply-To: <alpine.DEB.2.02.1210181737390.2689@kaball.uk.xensource.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/18/2012 09:44 AM, Stefano Stabellini wrote:
>
> I know that it is obvious but it is worth stating it in clear letters:
>
> these are Dan's personal opinions and by no means represent the position
> of the Xen community as a whole on this topic.
>
> I, for one, have no idea what he is talking about.
>

He is referring to the non-self-virtualizability of the pre-VT-x x86 
architecture; search for "Popek and Goldberg Virtualization Criteria". 
However, his response is misguided, because the issue at hand isn't the 
paravirtualization itself but the lack of documentation.

Paravirtualization creates a new platform, and that platform needs to be 
documented as much as any hardware platform.  Once that documentation 
exists it is possible to make a reasoned judgement if that platform can 
be unified with an existing platform like native x86.

However, the Xen platform is not documented in any useful way at all, 
and having "fun" little bits like this coming out of nowhere is just 
plain unacceptable.

Either way, it doesn't change the starting point of this -- we don't 
keep around hooks that aren't even used.  End of story.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

