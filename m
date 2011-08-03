Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751785Ab1HCGuc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 02:50:32 -0400
Received: from symlink.to.noone.org ([85.10.207.172]:51872 "EHLO sym.noone.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750811Ab1HCGu0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 02:50:26 -0400
Date: Wed, 3 Aug 2011 08:50:24 +0200
From: Tobias Klauser <tklauser@distanz.ch>
To: Thomas Meyer <thomas@m3y3r.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] Use resource_size()
Message-ID: <20110803065024.GL4587@distanz.ch>
References: <1312303347.2629.17.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1312303347.2629.17.camel@localhost.localdomain>
X-Editor: Vi IMproved 7.1
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-08-02 at 18:42:24 +0200, Thomas Meyer <thomas@m3y3r.de> wrote:
>  Use resource_size function on resource object
>  instead of explicit computation.
> 
>  The semantic patch that makes this output is available
>  in scripts/coccinelle/api/resource_size.cocci.
> 
>  More information about semantic patching is available at
>  http://coccinelle.lip6.fr/

You might want to split these up per driver or by subsystem and send it
to the respective maintainer.

Cheers Tobias
