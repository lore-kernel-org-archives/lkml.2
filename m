Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753844Ab1G0QnQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 12:43:16 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:42836 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753341Ab1G0QnN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 12:43:13 -0400
Date: Wed, 27 Jul 2011 18:42:57 +0200
From: Borislav Petkov <bp@amd64.org>
To: Avi Kivity <avi@redhat.com>
Cc: Borislav Petkov <bp@amd64.org>, Ingo Molnar <mingo@elte.hu>,
        "Przywara, Andre" <Andre.Przywara@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        "Pohlack, Martin" <Martin.Pohlack@amd.com>
Subject: Re: [PATCH] x86, AMD: Correct F15h IC aliasing issue
Message-ID: <20110727164257.GC19477@aftab>
References: <4E2F09BB.9060605@zytor.com>
 <4E2F1889.8030708@amd.com>
 <4E2F90A2.4030409@redhat.com>
 <20110727062120.GA5272@aftab>
 <20110727065932.GA16555@elte.hu>
 <4E2FDAD0.8000809@redhat.com>
 <20110727153731.GA19477@aftab>
 <4E30327C.5020509@redhat.com>
 <20110727154957.GB19477@aftab>
 <4E303579.4000903@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E303579.4000903@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 27, 2011 at 11:57:45AM -0400, Avi Kivity wrote:
> Out of curiosity, what's the performance impact if the workaround is
> not enabled?

Up to 3% for a CPU-intensive style benchmark, and it can vary highly in
a microbenchmark depending on workload and compiler.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
