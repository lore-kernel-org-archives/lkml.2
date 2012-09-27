Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754480Ab2I0QPF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 12:15:05 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51597 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754148Ab2I0QOn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 12:14:43 -0400
Message-ID: <50647B6D.8030106@suse.cz>
Date: Thu, 27 Sep 2012 18:14:37 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120825 Thunderbird/15.0
MIME-Version: 1.0
To: Benjamin Poirier <bpoirier@suse.de>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Randy Dunlap <rdunlap@xenotime.net>, Borislav Petkov <bp@alien8.de>,
        "Yann E. MORIN" <yann.morin.1998@free.fr>,
        Jean Sacren <sakiwit@gmail.com>, Arnaud Lacombe <lacombar@gmail.com>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Davidlohr Bueso <dave@gnu.org>, Wang YanQing <udknight@gmail.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Cheng Renquan <crquan@gmail.com>
Subject: Re: [PATCH v2 0/6] menuconfig: jump to search results
References: <1345748108-12206-1-git-send-email-bpoirier@suse.de>
In-Reply-To: <1345748108-12206-1-git-send-email-bpoirier@suse.de>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23.8.2012 20:55, Benjamin Poirier wrote:
> This patch series adds "jump to" keys (similar to the cscope interface) to the
> search results of "make menuconfig" so that we can go directly to the menu
> entry for a config option after searching for it.
> 
> Patches 1-4 implement the basic functionality.
> Patches 5-6 are an optional improvement.

Applied to kbuild.git#kconfig, thanks a lot.

Michal

