Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932121Ab0LRS2o (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Dec 2010 13:28:44 -0500
Received: from smtp.outflux.net ([198.145.64.163]:58451 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932080Ab0LRS2m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Dec 2010 13:28:42 -0500
Date: Sat, 18 Dec 2010 10:27:48 -0800
From: Kees Cook <kees.cook@canonical.com>
To: Dan Rosenberg <drosenberg@vsecurity.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-security-module@vger.kernel.org, jmorris@namei.org,
        eric.dumazet@gmail.com, tgraf@infradead.org, eugeneteo@kernel.org,
        mingo@elte.hu, davem@davemloft.net, a.p.zijlstra@chello.nl,
        akpm@linux-foundation.org
Subject: Re: [PATCH v3] kptr_restrict for hiding kernel pointers
Message-ID: <20101218182748.GG4810@outflux.net>
References: <1292692835.10804.67.camel@dan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1292692835.10804.67.camel@dan>
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 18, 2010 at 12:20:34PM -0500, Dan Rosenberg wrote:
> v3 adds the "2" setting, cleans up documentation, removes the CONFIG,
> and incorporates changes and suggestions from Andrew Morton.

Acked-by: Kees Cook <kees.cook@canonical.com>

-- 
Kees Cook
Ubuntu Security Team
