Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754805Ab1L2RVi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Dec 2011 12:21:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:24913 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752748Ab1L2RVf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Dec 2011 12:21:35 -0500
Date: Thu, 29 Dec 2011 12:21:02 -0500
From: Dave Jones <davej@redhat.com>
To: Lucas De Marchi <lucas.demarchi@profusion.mobi>
Cc: Michal Marek <mmarek@suse.cz>, Sam Ravnborg <sam@ravnborg.org>,
        linux-modules@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] kbuild: add target to install gzipped modules
Message-ID: <20111229172101.GB4101@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Lucas De Marchi <lucas.demarchi@profusion.mobi>,
	Michal Marek <mmarek@suse.cz>, Sam Ravnborg <sam@ravnborg.org>,
	linux-modules@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1325173819-26274-1-git-send-email-lucas.demarchi@profusion.mobi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1325173819-26274-1-git-send-email-lucas.demarchi@profusion.mobi>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 29, 2011 at 01:50:18PM -0200, Lucas De Marchi wrote:
 > Add target in Makefile to compress the module after it's installed.
 > Module-init-tools and libkmod can handle gzipped modules.
 > 
 > This is not much useful for distributions because the package will gzip
 > the modules and call depmod in a install rule. 

It might actually be a worthwhile thing for distributions.

For a Fedora kernel, gzipping modules saves around 80MB of diskspace per
installed kernel.  That the RPM is compressed is irrelevant, the on-disk
footprint is more interesting, given that the bulk of the modules installed
will never even be loaded.

	Dave

