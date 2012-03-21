Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759112Ab2CUQ0u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 12:26:50 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:17316 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754348Ab2CUQ0t convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 12:26:49 -0400
Date: Wed, 21 Mar 2012 12:22:23 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: suresh.b.siddha@intel.com, jwboyer@redhat.com, mingo@elte.hu,
        hpa@zytor.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] x86/apic_ops: Replace apic_ops with x86_apic_ops.
Message-ID: <20120321162223.GE13722@phenom.dumpdata.com>
References: <1332273919.16101.74.camel@sbsiddha-desk.sc.intel.com>
 <1332288764-10351-1-git-send-email-konrad.wilk@oracle.com>
 <1332288764-10351-3-git-send-email-konrad.wilk@oracle.com>
 <CAE9FiQVoSTB_zgZ7HeoFpFm6YrxwqRHDCMy3=+N8mf6FfdhNAg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <CAE9FiQVoSTB_zgZ7HeoFpFm6YrxwqRHDCMy3=+N8mf6FfdhNAg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-CT-RefId: str=0001.0A090206.4F6A013E.0003,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 20, 2012 at 07:31:51PM -0700, Yinghai Lu wrote:
> On Tue, Mar 20, 2012 at 5:12 PM, Konrad Rzeszutek Wilk
> <konrad.wilk@oracle.com> wrote:
> > . which makes the code fit within the rest of the x86_ops functions.
> > +
> > +struct x86_apic_ops x86_apic = {
> > +       .init = native_ioapic_init_mappings,
> > +       .read = native_ioapic_read,
> > +       .write = native_ioapic_write,
> > +       .modify = native_ioapic_modify,
> > +};
> 
> x86_ioapic_ops and x86_ioapic would be better?

It certainly would. Thank you for the suggestion!
> 
> Yinghai
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
