Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755300Ab2JCJRy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 05:17:54 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37612 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753836Ab2JCJRx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 05:17:53 -0400
Message-ID: <506C02BB.20606@suse.cz>
Date: Wed, 03 Oct 2012 11:17:47 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Jean Delvare <jdelvare@suse.de>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
        Bernhard Walle <bernhard@bwalle.de>,
        Ralf Baechle <ralf@linux-mips.org>, akpm@linux-foundation.org
Subject: Re: [PATCH v3] kbuild: Fix gcc -x syntax
References: <1349188956.4441.12.camel@amber.site>
In-Reply-To: <1349188956.4441.12.camel@amber.site>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2.10.2012 16:42, Jean Delvare wrote:
> The correct syntax for gcc -x is "gcc -x assembler", not
> "gcc -xassembler". Even though the latter happens to work, the former
> is what is documented in the manual page and thus what gcc wrappers
> such as icecream do expect.
> 
> This isn't a cosmetic change. The missing space prevents icecream from
> recognizing compilation tasks it can't handle, leading to silent kernel
> miscompilations.
> 
> Besides me, credits go to Michael Matz and Dirk Mueller for
> investigating the miscompilation issue and tracking it down to this
> incorrect -x parameter syntax.

Applied to kbuild.git#rc-fixes. Thanks to everyone involved.

Michal
