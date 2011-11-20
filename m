Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755304Ab1KTEe4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Nov 2011 23:34:56 -0500
Received: from mga02.intel.com ([134.134.136.20]:60557 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755138Ab1KTEez (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Nov 2011 23:34:55 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="78047950"
Subject: Re: iwlagn: memory corruption with WPA enterprise
From: wwguy <wey-yi.w.guy@intel.com>
To: =?UTF-8?Q?Tom=C3=A1=C5=A1_Janou=C5=A1ek?= <tomi@nomi.cz>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <20111120032016.GA14520@nomi.cz>
References: <20111110091816.GA2247@nomi.cz>
	 <20111110114732.GA2217@redhat.com> <20111110125347.GA29415@nomi.cz>
	 <20111110160703.GA2775@redhat.com> <20111110163051.GA24533@nomi.cz>
	 <20111111054731.GA2292@redhat.com> <20111111150105.GA25437@nomi.cz>
	 <20111114140714.GD2513@redhat.com> <20111119181106.GA5515@nomi.cz>
	 <1321755233.22510.1.camel@wwguy-ubuntu>  <20111120032016.GA14520@nomi.cz>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 19 Nov 2011 20:28:34 -0800
Message-ID: <1321763314.22510.4.camel@wwguy-ubuntu>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-11-19 at 19:20 -0800, Tomáš Janoušek wrote:
> Hi,
> 
> On Sat, Nov 19, 2011 at 06:13:53PM -0800, wwguy wrote:
> > hmm, I don't have any IOMMU supported system, I guess it is the time to
> > get one :-)
> 
> Well, the bug manifests itself regardless of whether IOMMU is used or not...
> 
> Anyway, did you have time to try to reproduce it with the .config I sent?
> (It may take hours, sometimes. :-/)
> 
Yes, I will try your configuration when I get back  to the office Monday

Thanks

Wey


