Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752669Ab1L3KYC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Dec 2011 05:24:02 -0500
Received: from cantor2.suse.de ([195.135.220.15]:58730 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751851Ab1L3KYA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Dec 2011 05:24:00 -0500
Message-ID: <4EFD913E.7010707@suse.cz>
Date: Fri, 30 Dec 2011 11:23:58 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Sam Ravnborg <sam@ravnborg.org>, linux-modules@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] kbuild: add target to install gzipped modules
References: <1325173819-26274-1-git-send-email-lucas.demarchi@profusion.mobi> <20111229172101.GB4101@redhat.com>
In-Reply-To: <20111229172101.GB4101@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29.12.2011 18:21, Dave Jones wrote:
> On Thu, Dec 29, 2011 at 01:50:18PM -0200, Lucas De Marchi wrote:
>  > Add target in Makefile to compress the module after it's installed.
>  > Module-init-tools and libkmod can handle gzipped modules.
>  > 
>  > This is not much useful for distributions because the package will gzip
>  > the modules and call depmod in a install rule. 
> 
> It might actually be a worthwhile thing for distributions.
> 
> For a Fedora kernel, gzipping modules saves around 80MB of diskspace per
> installed kernel.  That the RPM is compressed is irrelevant, the on-disk
> footprint is more interesting, given that the bulk of the modules installed
> will never even be loaded.

But it kills performance of the tools.

Michal
