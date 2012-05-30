Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754214Ab2E3Prq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 11:47:46 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39634 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751488Ab2E3Prp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 11:47:45 -0400
Message-ID: <4FC640B5.2080601@zytor.com>
Date: Wed, 30 May 2012 08:45:57 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Jan Beulich <JBeulich@suse.com>
CC: Borislav Petkov <bp@alien8.de>, Andre Przywara <andre.przywara@amd.com>,
        Jacob Shin <Jacob.Shin@amd.com>, mingo@elte.hu, jeremy@goop.org,
        tglx@linutronix.de, xen-devel@lists.xensource.com,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [Xen-devel] [PATCH] x86/amd: fix crash as Xen Dom0 on AMD Trinity
 systems
References: <1338383402-3838-1-git-send-email-andre.przywara@amd.com> <4FC63DAF0200007800086DC5@nat28.tlf.novell.com> <4FC62888.9010407@amd.com> <4FC649790200007800086E51@nat28.tlf.novell.com> <4FC631F0.9080109@zytor.com> <20120530144929.GH3207@phenom.dumpdata.com> <20120530151235.GB15635@x1.osrc.amd.com> <4FC65B950200007800086F5B@nat28.tlf.novell.com>
In-Reply-To: <4FC65B950200007800086F5B@nat28.tlf.novell.com>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/30/2012 08:40 AM, Jan Beulich wrote:
>>>> On 30.05.12 at 17:12, Borislav Petkov <bp@alien8.de> wrote:
>> This current case should be a perfect example for why xen shouldn't be
>> sprinkling code all over the place.
> 
> Which means you're denying the benefits of para-virtualization
> (at the base system level; perhaps it's less of a problem for you
> when it comes to pv device drivers, which are generally
> standalone entities) as that's what distinguishes Xen from all
> other virtualization solutions Linux supports.
> 

And it also denies the just atrocious cost of Xen grabbing random kernel
internals and turning them into ABIs that we have to work around from
that point on.  This is particularly obnoxious because the cost is
largely not borne by the Xen community but by the general Linux development.

	-hpa

