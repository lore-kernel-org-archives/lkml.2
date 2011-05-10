Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932332Ab1EJOr7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 10:47:59 -0400
Received: from casper.infradead.org ([85.118.1.10]:52822 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753926Ab1EJOrz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 10:47:55 -0400
Subject: Re: [PATCH 1/3] perf, core: Introduce attrs to count in either
 host or guest mode
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
In-Reply-To: <1305038132-5080-2-git-send-email-joerg.roedel@amd.com>
References: <1305038132-5080-1-git-send-email-joerg.roedel@amd.com>
	 <1305038132-5080-2-git-send-email-joerg.roedel@amd.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 10 May 2011 16:45:46 +0200
Message-ID: <1305038746.2914.94.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-05-10 at 16:35 +0200, Joerg Roedel wrote:
> +       /* Can't exclude counting in guest and in host mode */
> +       if (attr.exclude_host && attr.exclude_guest)
> +               return -EINVAL;

Why not?

