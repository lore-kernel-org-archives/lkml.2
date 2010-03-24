Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756149Ab0CXNxT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 09:53:19 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38739 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755688Ab0CXNxR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 09:53:17 -0400
Date: Wed, 24 Mar 2010 06:51:12 -0400
From: Andrew Morton <akpm@linux-foundation.org>
To: Huang Ying <ying.huang@intel.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Subject: Re: [BUGFIX] Fix AES-NI CTR optimization compiling failure with gas
 2.16.1
Message-Id: <20100324065112.823c8d4f.akpm@linux-foundation.org>
In-Reply-To: <1269411858.23970.26.camel@yhuang-dev.sh.intel.com>
References: <1268377307.1640.491.camel@yhuang-dev.sh.intel.com>
	<20100323142324.a53b20de.akpm@linux-foundation.org>
	<1269411858.23970.26.camel@yhuang-dev.sh.intel.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Mar 2010 14:24:18 +0800 Huang Ying <ying.huang@intel.com> wrote:

> Can you tell me how to setup the building environment with binutils
> 2.16.1? I just build it by hand and make the installed bin directory the
> first one in $PATH.

gcc searches an internal search patch before $PATH.  They say this can
be overridden with the -B option or the GCC_EXEC_PREFIX environment
var.

For once-off stuff I just get dirty and do `make V=1'.  Then copy and
paste the gcc command line and add `-v'.  Then copy, paste and edit the
various gcc subcommands.

