Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754886Ab2CZM0i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 08:26:38 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:60701 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752415Ab2CZM0h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 08:26:37 -0400
Date: Mon, 26 Mar 2012 14:26:32 +0200
From: Borislav Petkov <bp@amd64.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Borislav Petkov <bp@amd64.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] tools: Add a toplevel Makefile
Message-ID: <20120326122632.GC32090@aftab>
References: <1332513788-9726-1-git-send-email-bp@amd64.org>
 <20120324074412.GE20145@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120324074412.GE20145@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 24, 2012 at 08:44:12AM +0100, Ingo Molnar wrote:
> Could this also be accessible via 'make tools' in the toplevel 
> Makefile?
> 
> I'd love to be able to type:
> 
>   make -j tools perf install

Well,

you could do

$ make -j -C tools perf

which builds perf. I'd need to make it work with the install target too
so that when you do

$ make -j -C tools perf install

it knows that you mean the install target of perf. Let me play with it a
bit ...

[..]

> Btw., please fix the perf line to say:
> 
> s/performance measurements tool/performance measurement and analysis tool

Done,
thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
