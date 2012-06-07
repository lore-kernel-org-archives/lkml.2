Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932762Ab2FHN6G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 09:58:06 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:33251 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932339Ab2FHN6D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 09:58:03 -0400
Date: Thu, 7 Jun 2012 14:43:48 +0200
From: Borislav Petkov <bp@amd64.org>
To: Rob Herring <robherring2@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>, linux-edac@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH 1/2] edac: add support for Calxeda highbank memory
 controller
Message-ID: <20120607124348.GD11153@aftab.osrc.amd.com>
References: <1339020125-20198-1-git-send-email-robherring2@gmail.com>
 <1339020125-20198-2-git-send-email-robherring2@gmail.com>
 <4FCFDB12.3090403@redhat.com>
 <4FCFE028.10005@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FCFE028.10005@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 06, 2012 at 05:56:40PM -0500, Rob Herring wrote:
> > Hmm... I suspect that memories by DIMM chip select/channel at Calxeda,
> > as it is using just 1 cs/channel. It probably makes more sense to add new layer
> > type(s) to properly represent the way your memory controller addresses it, if
> > Calxeda doesn't work with DIMMs.
> 
> Not sure I follow. DIMMs are supported, but only a newer JEDEC form
> factor (DDR3 72-bit mini DIMM). The h/w pretty much fixed to a single
> 4GB DIMM. The controller is 1 72-bit channel.

Me too, why would this need a new define although those are more-or-less
normal DIMMs (modulo the form factor)?

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
