Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757418Ab2E3SVe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 14:21:34 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41368 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757401Ab2E3SVc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 14:21:32 -0400
Message-ID: <4FC6650C.5060604@zytor.com>
Date: Wed, 30 May 2012 11:21:00 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jacob Shin <jacob.shin@amd.com>,
        Andre Przywara <andre.przywara@amd.com>, jeremy@goop.org,
        xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org,
        Jan Beulich <JBeulich@suse.com>, mingo@elte.hu, tglx@linutronix.de
Subject: Re: [Xen-devel] [PATCH] x86/amd: fix crash as Xen Dom0 on AMD Trinity
 systems
References: <4FC62888.9010407@amd.com> <20120530144851.GA12184@jshin-Toonie> <20120530145005.GI3207@phenom.dumpdata.com> <20120530150334.GA13349@jshin-Toonie> <20120530171754.GA5115@phenom.dumpdata.com> <20120530173247.GC15635@x1.osrc.amd.com> <4FC65D34.1060803@zytor.com> <20120530175150.GE15438@x1.osrc.amd.com> <4FC66037.6020506@zytor.com> <20120530181722.GF15438@x1.osrc.amd.com> <20120530181950.GG15438@x1.osrc.amd.com>
In-Reply-To: <20120530181950.GG15438@x1.osrc.amd.com>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/30/2012 11:19 AM, Borislav Petkov wrote:
> On Wed, May 30, 2012 at 08:17:23PM +0200, Borislav Petkov wrote:
>> The other place where we use the amd_safe variants is an obscure K8,
>> revC and earlier fix for _some_ BIOSen and this hasn't bitten us yet
>> so I'm assuming people haven't run xen on such boxes yet. Does it need
>> fixing? Probably, if we really really have to.
> 
> I'm being told we're safe here. Those boxes didn't have virtualization
> support yet (SVM) so this one doesn't need fixing.
> 

This is for PV, not for HVM (VT-x/SVM).  HVM doesn't have this kind of
drain bamage.

	-hpa
