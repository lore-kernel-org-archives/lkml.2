Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756823Ab1DFUST (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 16:18:19 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:41289
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756769Ab1DFUSS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 16:18:18 -0400
Date: Wed, 06 Apr 2011 13:17:39 -0700 (PDT)
Message-Id: <20110406.131739.242138705.davem@davemloft.net>
To: simon@mungewell.org
Cc: gregkh@suse.de, david-b@pacbell.net, sshtylyov@mvista.com,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PatchV2 : PL25A1 Support - 1/3] whitespace
From: David Miller <davem@davemloft.net>
In-Reply-To: <1302063406-13077-1-git-send-email-simon@mungewell.org>
References: <1301456667-1648-1-git-send-email-simon@mungewell.org>
	<1302063406-13077-1-git-send-email-simon@mungewell.org>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


There are some problems with this patch series:

1) Please compose your subject lines more correctly.  When I such these
   patches into GIT, everything in the initial "[]" brackets is removed
   and the commit header line for this patch (for example) ends up being
   just "whitespace".

   We want more than that.

   Try something like:

	Subject: [PATCH v2 1/3] usb: plusb: Whitespace.
	Subject: [PATCH v2 2/3] usb: plusb: Add PL25A1 support.
	Subject: [PATCH v2 3/3] usb: plusb: Add reset debugging.

2) Patch 2 doesn't apply cleanly to the current tree, you'll need to
   refresh these patches.

Thanks.
