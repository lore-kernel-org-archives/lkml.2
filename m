Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756359Ab0KVCFM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Nov 2010 21:05:12 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45273
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755371Ab0KVCFK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Nov 2010 21:05:10 -0500
Date: Sun, 21 Nov 2010 18:05:35 -0800 (PST)
Message-Id: <20101121.180535.193735538.davem@davemloft.net>
To: tomoya-linux@dsn.okisemi.com
Cc: wg@grandegger.com, w.sang@pengutronix.de, chripell@fsfe.org,
        21cnbao@gmail.com, sameo@linux.intel.com,
        socketcan-core@lists.berlios.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, qi.wang@intel.com, yong.y.wang@intel.com,
        andrew.chih.howe.khor@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com, margie.foster@intel.com
Subject: Re: [PATCH net-next-2.6 7/17 v2] can: EG20T PCH: Modify
 function/macro name/type
From: David Miller <davem@davemloft.net>
In-Reply-To: <4CE9C6A4.1090809@dsn.okisemi.com>
References: <4CE9C6A4.1090809@dsn.okisemi.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


In case it isn't clear, you need to resubmit this entire
patch series after you've integrated all of our feedback.

It doesn't make sense to just resubmit specific pieces
that you fix, because each change you make causes
subsequent patches in the series to no longer apply
cleanly.
