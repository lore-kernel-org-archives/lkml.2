Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757941Ab0JYXEB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 19:04:01 -0400
Received: from claw.goop.org ([74.207.240.146]:56394 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753586Ab0JYXD7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 19:03:59 -0400
Message-ID: <4CC60CDD.8040209@goop.org>
Date: Mon, 25 Oct 2010 16:03:57 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Lightning/1.0b3pre Thunderbird/3.1.4
MIME-Version: 1.0
To: Ian Campbell <Ian.Campbell@eu.citrix.com>
CC: "H. Peter Anvin" <hpa@zytor.com>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "Xen-devel@lists.xensource.com" <Xen-devel@lists.xensource.com>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "tglx@linutronix.de" <tglx@linutronix.de>
Subject: Re: [PATCH 00/05] xen: events: cleanups after irq core improvements
 (Was: Re: [Xen-devel] Re: [tip:irq/core] x86: xen: Sanitise sparse_irq handling)
References: <tip-77dff1c755c3218691e95e7e38ee14323b35dbdb@git.kernel.org>	 <4CB8EE8A.5020900@goop.org> <4CB8EF30.7060504@goop.org>	 <6a6702dc-7dbb-47a3-a0cf-18c8a65252fe@email.android.com> <1288023736.11153.40.camel@zakaz.uk.xensource.com>
In-Reply-To: <1288023736.11153.40.camel@zakaz.uk.xensource.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 On 10/25/2010 09:22 AM, Ian Campbell wrote:
> I'm about to followup with an initial stab at some cleanups which are
> made possible by these core changes, including hanging the per-irq info
> off the handler_data.
>
> These patches are on top of recent Linus master tree plus Konrad's
> swiotlb-xen tree and Stefano's PVHVM tree since the latter in particular
> touches the same area.

This looks pretty good.  How much testing have you given it?  Do you
have a git branch I can pull?

Thanks,
    J
