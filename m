Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759120Ab0JGANG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 20:13:06 -0400
Received: from smtp.outflux.net ([198.145.64.163]:38617 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753934Ab0JGANF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 20:13:05 -0400
Date: Wed, 6 Oct 2010 17:12:36 -0700
From: Kees Cook <kees.cook@canonical.com>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Stefan Ringel <stefan.ringel@arcor.de>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH] staging: fix possible use-before-NULL-check crash
Message-ID: <20101007001236.GY14666@outflux.net>
References: <20101006223941.GW14666@outflux.net>
 <20101006225104.GA21013@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101006225104.GA21013@suse.de>
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

On Wed, Oct 06, 2010 at 03:51:04PM -0700, Greg KH wrote:
> Nice catch, but I don't think that the dev pointer can ever be NULL
> here.

Yeah, I didn't think so either, but figured it was best to fix it anyway.

-Kees

-- 
Kees Cook
Ubuntu Security Team
