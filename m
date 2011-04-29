Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760948Ab1D2VNP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 17:13:15 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:51568
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751743Ab1D2VNN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 17:13:13 -0400
Date: Fri, 29 Apr 2011 14:12:40 -0700 (PDT)
Message-Id: <20110429.141240.233691679.davem@davemloft.net>
To: decot@google.com
Cc: bhutchings@solarflare.com, mirq-linux@rere.qmqm.pl, sgruszka@redhat.com,
        alexander.h.duyck@intel.com, eilong@broadcom.com,
        grundler@parisc-linux.org, e1000-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCHv3 0/7] ethtool: generalize use of ethtool_cmd_speed API
From: David Miller <davem@davemloft.net>
In-Reply-To: <1303954043-17440-1-git-send-email-decot@google.com>
References: <1303954043-17440-1-git-send-email-decot@google.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Decotigny <decot@google.com>
Date: Wed, 27 Apr 2011 18:27:16 -0700

> Third version of the patch series ensuring ethtool_cmd::speed/_hi
> fields are accessed using ethtool_cmd_speed/_set API. Thanks to Ben
> and Stephen for their feedbacks that have been integrated here,
> including some from Ben suggested in PATCHv1 and added here (intel GbE
> drivers: last patch in the series).

Great work David, all applied to net-next-2.6

Thanks!
