Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757837Ab2JQUgQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 16:36:16 -0400
Received: from mail.x86-64.org ([217.9.48.20]:52875 "EHLO mail.x86-64.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755580Ab2JQUgP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 16:36:15 -0400
Date: Wed, 17 Oct 2012 22:36:12 +0200
From: Borislav Petkov <bp@amd64.org>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: Tony Luck <tony.luck@intel.com>,
        "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: Re: [PATCH 1/5] drivers/base: Add a DEVICE_BOOL_ATTR macro
Message-ID: <20121017203612.GE32230@aftab.osrc.amd.com>
References: <1350472435-29307-1-git-send-email-bp@amd64.org>
 <1350472435-29307-2-git-send-email-bp@amd64.org>
 <20121017190300.GB25996@kroah.com>
 <20121017201018.GC32230@aftab.osrc.amd.com>
 <20121017202900.GA30907@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121017202900.GA30907@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 17, 2012 at 01:29:00PM -0700, Greg Kroah-Hartman wrote:
> Take the function already from the module code, it should be reusable,
> if not, it would be a good idea to make it so.

Function from module code? Do you mean param_get_bool/param_set_bool in
kernel/params.c?

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
