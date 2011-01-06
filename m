Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754816Ab1AFW2h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 17:28:37 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:41397
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754560Ab1AFW2e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 17:28:34 -0500
Date: Thu, 06 Jan 2011 14:29:06 -0800 (PST)
Message-Id: <20110106.142906.226774601.davem@davemloft.net>
To: alex.buell@munted.org.uk
Cc: romieu@fr.zoreil.com, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Using s3virge card in Sun Blade 2000
From: David Miller <davem@davemloft.net>
In-Reply-To: <1294352651.24378.17.camel@lithium>
References: <20110106204240.GA6361@electric-eye.fr.zoreil.com>
	<1294347036.24378.13.camel@lithium>
	<1294352651.24378.17.camel@lithium>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


You have to initialize par->state.vgabase in the s3fb driver to the
VGA area iomem pointer you calculated at boot time.
