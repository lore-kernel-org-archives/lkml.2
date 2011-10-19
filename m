Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756923Ab1JSRN5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 13:13:57 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:57248 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756962Ab1JSRNx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 13:13:53 -0400
Date: Wed, 19 Oct 2011 19:13:51 +0200
From: Borislav Petkov <bp@amd64.org>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: EDAC devel <linux-edac@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        X86-ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC -v2] x86 RAS: Reorganize functionality
Message-ID: <20111019171351.GA29064@gere.osrc.amd.com>
References: <1319035866-29570-1-git-send-email-bp@amd64.org>
 <987664A83D2D224EAE907B061CE93D5301F19DBD9F@orsmsx505.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <987664A83D2D224EAE907B061CE93D5301F19DBD9F@orsmsx505.amr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 19, 2011 at 10:08:25AM -0700, Luck, Tony wrote:
> > and what I actually would like to see is something like
> 
> [ ] Reliability, Availability, Serviceability
> [ ]  Machine Check Architecture
> [ ]	Intel-specific features
> 	[ ] CMCI / overheating reporting
> 	[ ] MCE decoding
> 	[ ] MCE injection
> [ ]	AMD-specific features
> 	[ ] Error thresholding
> 	[ ] MCE decoding
> 	[ ] MCE injection
> [ ] ...
> 
> Where does EINJ and other APEI bits fit into this ... it isn't Intel
> specific (Is it? Do AMD BIOS writers include it??).

I'll have to check on that but...

> It would be nice for it to eventually move in with the other "RAS"
> bit, rather than being hidden under a couple of levels of ACPI menus.

... absolutely, that's what the "[ ] ..." was supposed to mean - other
RAS features which should go there eventually.

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
