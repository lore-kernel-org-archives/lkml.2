Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756204Ab2E3R2S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 13:28:18 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:37318 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756041Ab2E3R2R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 13:28:17 -0400
Date: Wed, 30 May 2012 19:28:44 +0200
From: Borislav Petkov <bp@amd64.org>
To: "Liu, Jinsong" <jinsong.liu@intel.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "Luck, Tony" <tony.luck@intel.com>,
        "'xen-devel@lists.xensource.com'" <xen-devel@lists.xensource.com>
Subject: Re: [PATCH 1/3] xen/mce: Add mcelog support for Xen platform (RFC)
Message-ID: <20120530172844.GG4771@aftab.osrc.amd.com>
References: <DE8DF0795D48FD4CA783C40EC82923351F0C4E@SHSMSX101.ccr.corp.intel.com>
 <20120525180102.GA27280@phenom.dumpdata.com>
 <DE8DF0795D48FD4CA783C40EC82923351F0D53@SHSMSX101.ccr.corp.intel.com>
 <DE8DF0795D48FD4CA783C40EC82923351F44F3@SHSMSX101.ccr.corp.intel.com>
 <20120529133858.GD29157@aftab.osrc.amd.com>
 <DE8DF0795D48FD4CA783C40EC82923351FC452@SHSMSX101.ccr.corp.intel.com>
 <20120530150827.GA12109@phenom.dumpdata.com>
 <DE8DF0795D48FD4CA783C40EC82923351FC523@SHSMSX101.ccr.corp.intel.com>
 <20120530152948.GD4771@aftab.osrc.amd.com>
 <DE8DF0795D48FD4CA783C40EC82923351FCA4F@SHSMSX101.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DE8DF0795D48FD4CA783C40EC82923351FCA4F@SHSMSX101.ccr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 30, 2012 at 05:21:47PM +0000, Liu, Jinsong wrote:
> do you mean 'late_initcall <- threshold_init_device'?

Yes sir, that's what I meant.

Sorry :).

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
