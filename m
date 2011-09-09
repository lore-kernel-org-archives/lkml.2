Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933210Ab1IIJqT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 05:46:19 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37929 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758667Ab1IIJqR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 05:46:17 -0400
Message-ID: <4E69E067.8080302@suse.cz>
Date: Fri, 09 Sep 2011 11:46:15 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110812 Thunderbird/6.0
MIME-Version: 1.0
To: Peter Foley <pefoley2@verizon.net>
Cc: Arnaud Lacombe <lacombar@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Kbuild Mailing List <linux-kbuild@vger.kernel.org>,
        rdunlap@xenotime.net
Subject: Re: [PATCH v2] kconfig.h fix extraneous dependencies
References: <alpine.LNX.2.00.1107311812460.62769@linux> <CACqU3MWfOg+ZhUGAovWsds48Y37i7GRk7qSxWvt7-JmLMBcmgg@mail.gmail.com> <alpine.LNX.2.00.1107312055360.20006@linux> <4E3670BF.6000709@suse.cz> <alpine.LNX.2.00.1108010945280.3043@linux>
In-Reply-To: <alpine.LNX.2.00.1108010945280.3043@linux>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1.8.2011 15:51, Peter Foley wrote:
> The introduction of include/linux/kconfig.h created 3 extraneous 
> dependencies:
> include/config/.h 
> include/config/h.h 
> include/config/foo.h 
> 
> Fix this by excluding kconfig.h from fixdep calculations.
> 
> Signed-off-by: Peter Foley <pefoley2@verizon.net>

Applied to kbuild-2.6.git#kbuild.

Michal
