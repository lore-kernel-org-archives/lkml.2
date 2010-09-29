Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753124Ab0I2PDd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 11:03:33 -0400
Received: from cantor.suse.de ([195.135.220.2]:32799 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752729Ab0I2PDb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 11:03:31 -0400
Message-ID: <4CA35541.9090106@suse.cz>
Date: Wed, 29 Sep 2010 17:03:29 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100714 SUSE/3.1.1 Thunderbird/3.1.1
MIME-Version: 1.0
To: matt mooney <mfm@muteddisk.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] Documentation/kbuild: correct variable definitions in
 makefiles.txt
References: <1284964412-32211-1-git-send-email-mfm@muteddisk.com>
In-Reply-To: <1284964412-32211-1-git-send-email-mfm@muteddisk.com>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20.9.2010 08:33, matt mooney wrote:
> Change $(src) and $(obj) definitions to state the path as absolute and
> not relative.

It _is_ a relative patch, AFAICS. What makes you think otherwise?

BTW, I applied your patches to modules.txt, thanks for them.

Michal
