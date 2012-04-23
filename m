Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753488Ab2DWR0W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 13:26:22 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54983 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752547Ab2DWR0V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 13:26:21 -0400
References: <DE8DF0795D48FD4CA783C40EC8292335154EFC@SHSMSX101.ccr.corp.intel.com> <20120421041454.GA29704@phenom.dumpdata.com> <20120421104502.GB17005@aftab.osrc.amd.com> <3908561D78D1C84285E8C5FCA982C28F170EF841@ORSMSX104.amr.corp.intel.com> <DE8DF0795D48FD4CA783C40EC8292335168D26@SHSMSX101.ccr.corp.intel.com> <4F9582C2.6020009@zytor.com> <20120423170507.GD22364@phenom.dumpdata.com>
User-Agent: K-9 Mail for Android
In-Reply-To: <20120423170507.GD22364@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [Xen-devel] [PATCH 1/3] Add mcelog support for xen platform
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Mon, 23 Apr 2012 10:23:55 -0700
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: "Liu, Jinsong" <jinsong.liu@intel.com>, "Luck, Tony" <tony.luck@intel.com>,
        Borislav Petkov <bp@amd64.org>, "x86@kernel.org" <x86@kernel.org>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Message-ID: <f6e39d21-e5d9-4558-b3a4-11437b664951@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I know.  It is very frustrating to me that this comes now rather than before Xen was merged, but changing the past is hard.  At least you are trying to fix it.

Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:

>On Mon, Apr 23, 2012 at 09:26:42AM -0700, H. Peter Anvin wrote:
>> On 04/23/2012 08:43 AM, Liu, Jinsong wrote:
>> > 
>> > and, hypervisor only record error into its mc_info cookie (in its
>> > own format), it doesn't care what's dom0's version and how dom0
>translate it
>> > -- that's dom0's business. The role of hypervisor is virtual
>'platform',
>> > just like h/w platform don't care what linux version runs over it.
>> > 
>> 
>> And this is the *OTHER* problem with Xen.  A platform is only a
>platform
>> if it is documented.  There are a number of PV hypervisors which
>*are*
>> documented in detail, but Xen is not one of them.
>
>And slowly we are working on that. As I mentioned to you, we are in
>process
>of documenting those calls so that there is a document similar to an
>SDM.
>It takes time though.

-- 
Sent from my mobile phone. Please excuse brevity and lack of formatting.
