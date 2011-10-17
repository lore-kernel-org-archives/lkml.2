Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755130Ab1JQHyE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 03:54:04 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:44270 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752695Ab1JQHyC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 03:54:02 -0400
Date: Mon, 17 Oct 2011 09:53:35 +0200
From: Borislav Petkov <bp@amd64.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: "Seidel, Conny" <Conny.Seidel@amd.com>, Tejun Heo <tj@kernel.org>,
        "Herrmann3, Andreas" <Andreas.Herrmann3@amd.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "JBeulich@novell.com" <JBeulich@novell.com>, x86 <x86@kernel.org>
Subject: Re: WARNING: at arch/x86/kernel/apic/apic.c:1239 setup_local_APIC+...
Message-ID: <20111017075335.GB4940@aftab>
References: <20111014135516.GC11990@aftab>
 <20111014165604.GA14286@aftab>
 <20111014175556.GE4294@google.com>
 <20111015221215.GA25519@aftab>
 <20111017000759.3d1f4310.conny.seidel@amd.com>
 <20111017072352.GA4940@aftab>
 <20111017073811.GA3675@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111017073811.GA3675@elte.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 17, 2011 at 03:38:11AM -0400, Ingo Molnar wrote:
> Yeah, it's still lined up in -tip:x86/apic for a v3.2 merge.

Cool,
thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
