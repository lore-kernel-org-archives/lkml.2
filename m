Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755799Ab2K1SJy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 13:09:54 -0500
Received: from mx1.redhat.com ([209.132.183.28]:24403 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755556Ab2K1SJw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 13:09:52 -0500
Message-ID: <1354126140.1694.0.camel@t520.localdomain>
Subject: Re: [PATCH V7 5/7] c6x: use new common dtc rule
From: Mark Salter <msalter@redhat.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Michal Marek <mmarek@suse.cz>, Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Sam Ravnborg <sam@ravnborg.org>,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>,
        Aurelien Jacquiot <a-jacquiot@ti.com>, linux-c6x-dev@linux-c6x.org
Date: Wed, 28 Nov 2012 13:09:00 -0500
In-Reply-To: <1354058956-7199-5-git-send-email-swarren@wwwdotorg.org>
References: <1354058956-7199-1-git-send-email-swarren@wwwdotorg.org>
	 <1354058956-7199-5-git-send-email-swarren@wwwdotorg.org>
Organization: Red Hat, Inc
Content-Type: text/plain; charset="us-ascii"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-11-27 at 16:29 -0700, Stephen Warren wrote:
> From: Stephen Warren <swarren@nvidia.com>
> 
> The current rules have the .dtb files build in a different directory
> from the .dts files. This patch changes c6x to use the generic dtb
> rule which builds .dtb files in the same directory as the source .dts.
> 
> This requires moving parts of arch/c6x/boot/Makefile into newly created
> arch/c6x/boot/dts/Makefile, and updating arch/c6x/Makefile to call the
> new Makefile. linked_dtb.S is also moved into boot/dts/ since it's used
> by rules that were moved.
> 
> Cc: Mark Salter <msalter@redhat.com>
> Cc: Aurelien Jacquiot <a-jacquiot@ti.com>
> Cc: linux-c6x-dev@linux-c6x.org
> Signed-off-by: Stephen Warren <swarren@nvidia.com>
> ---

Acked-by: Mark Salter <msalter@redhat.com>


