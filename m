Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753090Ab0DTFDX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 01:03:23 -0400
Received: from 1wt.eu ([62.212.114.60]:63434 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751598Ab0DTFDW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 01:03:22 -0400
Date: Tue, 20 Apr 2010 07:03:19 +0200
From: Willy Tarreau <w@1wt.eu>
To: Sylvain Rochet <gradator@gradator.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: PATCH: 2.4.37.9 MTU change for TUN/TAP interfaces
Message-ID: <20100420050318.GA7798@1wt.eu>
References: <20100407195724.GA4830@gradator.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100407195724.GA4830@gradator.net>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Sylvain,

On Wed, Apr 07, 2010 at 09:57:24PM +0200, Sylvain Rochet wrote:
> Hi,
> 
> This patch add the ability to change the MTU of TUN/TAP interfaces for 
> the 2.4.x kernels series.

I never noticed it was not possible to change the MTU on TUN devices,
and you seem to be the first one to report it !

Well, considering that 2.6 already supports this and that the change
is obvious, I'm OK to merge it.

Thanks,
Willy

