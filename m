Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756865Ab2IQRcK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 13:32:10 -0400
Received: from mail.x86-64.org ([217.9.48.20]:54375 "EHLO mail.x86-64.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754774Ab2IQRcH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 13:32:07 -0400
Date: Mon, 17 Sep 2012 19:32:04 +0200
From: Borislav Petkov <bp@amd64.org>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: X86-ML <x86@kernel.org>, EDAC devel <linux-edac@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] x86, mce: Enable MCA support by default
Message-ID: <20120917173204.GJ13879@aftab.osrc.amd.com>
References: <1347900723-17490-1-git-send-email-bp@amd64.org>
 <1347900723-17490-2-git-send-email-bp@amd64.org>
 <3908561D78D1C84285E8C5FCA982C28F19D41BC2@ORSMSX108.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F19D41BC2@ORSMSX108.amr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 17, 2012 at 05:30:00PM +0000, Luck, Tony wrote:
> > MCA is the basic support for hardware error logging and reporting, and
> > it is majorly unwise to run without it so enable machine check software
> > support by default on x86.
> 
> Acked-by: Tony Luck <tony.luck@intel.com>

Thanks Tony.

Will send a pull request shortly.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
