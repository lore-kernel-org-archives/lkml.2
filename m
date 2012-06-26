Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753599Ab2FZUqE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 16:46:04 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:35799 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751254Ab2FZUqB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 16:46:01 -0400
Date: Tue, 26 Jun 2012 22:45:56 +0200
From: Borislav Petkov <bp@amd64.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: shuox.liu@intel.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@alien8.de>,
        Yanmin Zhang <yanmin_zhang@linux.intel.com>, andi@firstfloor.org,
        Tony Luck <tony.luck@intel.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH v4 2/2] x86 mce: use new printk recursion disabling
 interface
Message-ID: <20120626204556.GB29439@aftab.osrc.amd.com>
References: <20120524155611.b7aeff4d.akpm@linux-foundation.org>
 <1337905811.14538.206.camel@ymzhang.sh.intel.com>
 <4FBF3295.7090608@intel.com>
 <4FBF32E8.90101@intel.com>
 <20120525074114.GA5417@liondog.tnic>
 <4FC2DDFF.3020600@intel.com>
 <20120530090844.GA23663@liondog.tnic>
 <4FCC25D3.7070308@intel.com>
 <4FCC265F.5@intel.com>
 <20120622164143.bb7dc290.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120622164143.bb7dc290.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 22, 2012 at 04:41:43PM -0700, Andrew Morton wrote:
> A couple of things here.
> 
> a) mce_panic() has a "return" statement deep inside.  So we return
>    from mce_panic() with the recursion check disabled.  whoops.

Yeah, you're staring at v4 and we fixed this later (currently discussing
v7, please follow this thread :))

> b) adding a nice comment is nice.

Agreed, if the actual use case pans out and we really need this
interface...

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
