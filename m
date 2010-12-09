Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755190Ab0LIJ2v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 04:28:51 -0500
Received: from violet.fr.zoreil.com ([92.243.8.30]:39044 "EHLO
	violet.fr.zoreil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754830Ab0LIJ2r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 04:28:47 -0500
Date: Thu, 9 Dec 2010 10:28:04 +0100
From: Francois Romieu <romieu@fr.zoreil.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: David Miller <davem@davemloft.net>, Matthew Garrett <mjg@redhat.com>,
        netdev@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Linux-pm mailing list <linux-pm@lists.linux-foundation.org>
Subject: Re: [PATCH, post-2.6.36 regression fix] r8169: Fix runtime power management
Message-ID: <20101209092804.GA4113@electric-eye.fr.zoreil.com>
References: <201012090232.14375.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201012090232.14375.rjw@sisk.pl>
User-Agent: Mutt/1.4.2.2i
X-Organisation: Land of Sunshine Inc.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki <rjw@sisk.pl> :
[...]
> I noticed that one of the post-2.6.36 patches broke runtime PM of the
> r8169 on my MSI Wind test machine in such a way that the link was not
> brought up after reconnecting the network cable.
> 
> In the process of debugging the issue I realized that we only should
> invoke the runtime PM functions in rtl8169_check_link_status() when
> link change is reported and if we do so, the problem goes away.
> Moreover, this allows rtl8169_runtime_idle() to be simplified quite
> a bit.
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

Acked-by: Francois Romieu <romieu@fr.zoreil.com>

-- 
Ueimor
