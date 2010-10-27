Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753820Ab0J0Wqd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 18:46:33 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40876 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752046Ab0J0Wqb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 18:46:31 -0400
Message-ID: <4CC8ABC7.5030003@suse.cz>
Date: Thu, 28 Oct 2010 00:46:31 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.1.11) Gecko/20100714 SUSE/3.0.6 Thunderbird/3.0.6
MIME-Version: 1.0
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: Hendrik Brueckner <brueckner@linux.vnet.ibm.com>,
        Michael Holzheu <holzheu@linux.vnet.ibm.com>, tabbott@ksplice.com,
        vda.linux@googlemail.com, hpa@linux.intel.com,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        heiko.carstens@de.ibm.com, schwidefsky@de.ibm.com,
        Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH] initramfs: Fix build break on symbol-prefixed archs
References: <20100831082307.064687027@linux.vnet.ibm.com> <20100831083844.043619334@linux.vnet.ibm.com> <AANLkTikCLHh5Uz-DRq9ws78We+SwCAqdurA6HfuJh-8Y@mail.gmail.com> <20101018103729.GA4122@linux.vnet.ibm.com> <AANLkTikKJ25L=6b2resz+0SAg7ZYL5j=rHG7Lg4kFbwd@mail.gmail.com> <20101019110801.GA4128@linux.vnet.ibm.com> <AANLkTimLi8BYy_u8NhD15s=+iiODzuG1H_CgZ-cd7jep@mail.gmail.com> <20101019213112.GA11432@merkur.ravnborg.org> <AANLkTike6UQVWKSz-Njs5Rps690EHeResH3V+aSM+qdO@mail.gmail.com> <AANLkTimn8R-qde8FH_cNa4JPcR2F=mkUAQhPVT-hOBhn@mail.gmail.com>
In-Reply-To: <AANLkTimn8R-qde8FH_cNa4JPcR2F=mkUAQhPVT-hOBhn@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27.10.2010 20:23, Mike Frysinger wrote:
> can we get this change dropped from linux-next until someone gets a
> chance to fix it ?

Sorry I missed this thread. So your last patch
(http://lkml.org/lkml/2010/10/19/488) did fix the Blackfin build
failure? Can you submit it with a proper Signed-off-by and changelog?

Thanks a lot,
Michal
