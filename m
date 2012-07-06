Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757763Ab2GFPh7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 11:37:59 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:37375 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757650Ab2GFPh6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 11:37:58 -0400
Message-ID: <1341589077.3661.3.camel@joe2Laptop>
Subject: Re: [PATCH v2 net-next 2/2] r8169: support RTL8168G
From: Joe Perches <joe@perches.com>
To: Francois Romieu <romieu@fr.zoreil.com>
Cc: Hayes Wang <hayeswang@realtek.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Fri, 06 Jul 2012 08:37:57 -0700
In-Reply-To: <20120706152046.GB6981@electric-eye.fr.zoreil.com>
References: <1340966060-2749-1-git-send-email-hayeswang@realtek.com>
	 <1341221002-1522-1-git-send-email-hayeswang@realtek.com>
	 <1341221002-1522-2-git-send-email-hayeswang@realtek.com>
	 <20120704220458.GA1621@electric-eye.fr.zoreil.com>
	 <1341449507.2058.6.camel@joe2Laptop>
	 <20120706152046.GB6981@electric-eye.fr.zoreil.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-07-06 at 17:20 +0200, Francois Romieu wrote:
> Joe Perches <joe@perches.com> :
> [...]
> > This pattern is used a couple more times.
> > There's no failure handling either.
> 
> I can do something for the initialize path. Other than that it's mostly
> deeply burried hardware failure so I'd rather concentrate a bit on 
> current problem reports.
> 
> This series already took me a bit further than expected (see below).

Allez Francois.

When you take up a suggestion, you really go with it.


