Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756245Ab1EZHui (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 03:50:38 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:14522 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755784Ab1EZHuh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 03:50:37 -0400
Date: Thu, 26 May 2011 09:49:05 +0200
From: Jean Delvare <khali@linux-fr.org>
To: "Yu, Fenghua" <fenghua.yu@intel.com>, Andi Kleen <andi@firstfloor.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>, Jan Beulich <jbeulich@novell.com>
Subject: Re: [PATCH 3/3] coretemp: Get microcode revision from cpu_data v2
Message-ID: <20110526094905.536ca3f1@endymion.delvare>
In-Reply-To: <493994B35A117E4F832F97C4719C4C04011E2157D6@orsmsx505.amr.corp.intel.com>
References: <1306351948-23382-1-git-send-email-andi@firstfloor.org>
	<1306351948-23382-3-git-send-email-andi@firstfloor.org>
	<20110525225359.60d819d5@endymion.delvare>
	<493994B35A117E4F832F97C4719C4C04011E2157D6@orsmsx505.amr.corp.intel.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 May 2011 19:08:27 -0700, Yu, Fenghua wrote:
> > -----Original Message-----
> > From: Jean Delvare [mailto:khali@linux-fr.org]
> > Sent: Wednesday, May 25, 2011 1:54 PM
> > To: Andi Kleen
> > Cc: x86@kernel.org; linux-kernel@vger.kernel.org; Andi Kleen;
> > jbeulich@novell.com; Yu, Fenghua
> > Subject: Re: [PATCH 3/3] coretemp: Get microcode revision from cpu_data
> > v2
> > 
> > Hi Andi,
> > 
> > On Wed, 25 May 2011 12:32:28 -0700, Andi Kleen wrote:
> > > From: Andi Kleen <ak@linux.intel.com>
> > >
> > > Now that the ucode revision is available in cpu_data remove
> > > the existing code in coretemp.c to query it manually. Read the ucode
> > > revision from cpu_data instead
> > 
> > Where is this available? Not upstream yet, apparently. I get a build
> > failure here.
> > 
> 
> This is one of three patches. Cpu_data is defined in the first patch. You need to get the other two to test them.

OK, thanks. This is (build-)tested now.

Acked-by: Jean Delvare <khali@linux-fr.org>

Andi, do you plan to merge this in 2.6.40 or later?

-- 
Jean Delvare
