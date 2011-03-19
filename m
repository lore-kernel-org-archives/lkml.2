Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755690Ab1CSJUB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Mar 2011 05:20:01 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:35856 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754564Ab1CSJTy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Mar 2011 05:19:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=IedBJBLQX033N3v3sOTRGcQFfmtj4DmsHpEb8d58+ENVBc7nY5z/6nZUlKFW8fuYyT
         ETpVTiVh+L6q72Ogw30fcqTGcRjgkSN/cl5p5YNFCrTcgXbtRfxrzqriicMc9ABISwyc
         dmCcSXdCiVswiez/S8t04GxjZwW6wEAYboAwk=
Date: Sat, 19 Mar 2011 10:19:46 +0100
From: Richard Cochran <richardcochran@gmail.com>
To: Mike Frysinger <vapier@gentoo.org>
Cc: linux-kernel@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org
Subject: Re: [PATCH 00/32] Blackfin updates for 2.6.39-rc0
Message-ID: <20110319091946.GA11644@riccoc20.at.omicron.at>
References: <1300471877-3544-1-git-send-email-vapier@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1300471877-3544-1-git-send-email-vapier@gentoo.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 18, 2011 at 02:11:17PM -0400, Mike Frysinger wrote:
> Philippe Gerum (3):
>   Blackfin/ipipe: upgrade to I-pipe mainline
>   Blackfin/ipipe: fix deferred pipeline sync for the root stage
>   Blackfin/ipipe: restore pipeline bits in irqflags

So, is adeos/ipipe specific code being considered for acceptance into
mainline Linux these days?

Thanks,

Richard
