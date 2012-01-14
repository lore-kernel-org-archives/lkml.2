Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758044Ab2ANWaE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jan 2012 17:30:04 -0500
Received: from cantor2.suse.de ([195.135.220.15]:56638 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751504Ab2ANWaB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jan 2012 17:30:01 -0500
Message-ID: <4F1201E4.9050000@suse.cz>
Date: Sat, 14 Jan 2012 23:29:56 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Stephen Warren <swarren@nvidia.com>
Cc: Jon Loeliger <jdl@jdl.com>, David Gibson <david@gibson.dropbear.id.au>,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Devicetree Discuss <devicetree-discuss@lists.ozlabs.org>
Subject: Re: [PATCH V2] dtc: Implement -d option to write out a dependency
 file
References: <1326241672-9168-1-git-send-email-swarren@nvidia.com>
In-Reply-To: <1326241672-9168-1-git-send-email-swarren@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11.1.2012 01:27, Stephen Warren wrote:
> This will allow callers to rebuild .dtb files when any of the /include/d
> .dtsi files are modified, not just the top-level .dts file.
> 
> Signed-off-by: Stephen Warren <swarren@nvidia.com>
> ---
> Michal, this patch is a dependency for the kbuild changes that use it;
> http://www.spinics.net/lists/linux-kbuild/msg05883.html
> I think it makes sense to apply both this patch, and that patch, to the
> kbuild tree. Do you agree?

Sure.


> v2: Replace fputs/fputc with fprintf
> 
> This patch has been blessed for application to upstream dtc. Here, I'm
> simply applying the same thing to the code in the Linux kernel tree,
> resolving some conflicts. See:
> http://lists.ozlabs.org/pipermail/devicetree-discuss/2012-January/011172.html

I see it has been applied in the meantime, great. I'll apply this one
and the kbuild patch to kbuild.git#kbuild.

Michal
