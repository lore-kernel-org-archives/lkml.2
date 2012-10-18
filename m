Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932715Ab2JRSCJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 14:02:09 -0400
Received: from smtp.citrix.com ([66.165.176.89]:23924 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932179Ab2JRSCH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 14:02:07 -0400
X-IronPort-AV: E=Sophos;i="4.80,608,1344211200"; 
   d="scan'208";a="41718371"
Message-ID: <5080441A.4020907@citrix.com>
Date: Thu, 18 Oct 2012 19:02:02 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20120428 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad@kernel.org>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, "lenb@kernel.org" <lenb@kernel.org>
Subject: Re: [Xen-devel] Is: axe read_tscp pvops call. Was: Re: [RFC] ACPI
 S3 and Xen (suprisingly small\!).
References: <1350481786-4969-1-git-send-email-konrad.wilk@oracle.com> <507ED6C0.4020503@zytor.com> <20121017161036.GA10691@phenom.dumpdata.com> <507EE1C3.7070300@zytor.com> <20121017165452.GA22740@phenom.dumpdata.com> <50802EEC.6060102@citrix.com> <20121018174200.GA20508@localhost.localdomain>
In-Reply-To: <20121018174200.GA20508@localhost.localdomain>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18/10/12 18:42, Konrad Rzeszutek Wilk wrote:
>> As for 'perf', since Xen already provides a virtual PMU for HVM guests
>> It's not clear why we would spend the effort to implement another
>> mechanism for PV guests (instead of using the virtual PMU from a PVH guest).
> 
> Would that allow one to evaluate the performance/bottlenecks that the
> hypervisor might have?

Not right now, no. But I don't so why it couldn't be possible.

David

