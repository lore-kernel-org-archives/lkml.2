Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759276Ab2C2Mda (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 08:33:30 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:60892 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752583Ab2C2Md0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 08:33:26 -0400
Date: Thu, 29 Mar 2012 14:33:20 +0200
From: Borislav Petkov <bp@amd64.org>
To: Pekka Enberg <penberg@kernel.org>
Cc: Christoph Lameter <cl@linux.com>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org
Subject: Re: [PATCH 2/2] tools: Add a toplevel Makefile
Message-ID: <20120329123320.GC6409@aftab>
References: <1332435713-32143-1-git-send-email-bp@amd64.org>
 <1332435713-32143-3-git-send-email-bp@amd64.org>
 <alpine.DEB.2.00.1203221332390.25011@router.home>
 <20120322210431.GA1462@aftab>
 <alpine.DEB.2.00.1203221646450.32581@router.home>
 <alpine.LFD.2.02.1203261326310.7116@tux.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1203261326310.7116@tux.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 26, 2012 at 01:27:11PM +0300, Pekka Enberg wrote:
> Didn't Andrew already patches that moved this under tools/vm and added
> proper Makefiles for it?

Yeah, he did. It went upstream on Wed:

commit 63e315535abe0d820d0e3db4c06bc5de74aeefc8
Author: Dave Young <dyoung@redhat.com>
Date:   Wed Mar 28 14:42:55 2012 -0700

    mm: move slabinfo.c to tools/vm

    We have tools/vm/ folder for vm tools, so move slabinfo.c from tools/slub/
    to tools/vm/

I'll have to readjust my patchset then.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
