Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752890Ab1BDVGQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 16:06:16 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47719
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752798Ab1BDVGO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 16:06:14 -0500
Date: Fri, 04 Feb 2011 13:06:49 -0800 (PST)
Message-Id: <20110204.130649.112613896.davem@davemloft.net>
To: kurt.van.dijck@eia.be
Cc: segoon@openwall.com, linux-kernel@vger.kernel.org, security@kernel.org,
        wg@grandegger.com, socketcan-core@lists.berlios.de,
        netdev@vger.kernel.org
Subject: Re: [PATCH 12/20] net: can: at91_can: world-writable sysfs files
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110204124233.GB334@e-circ.dyndns.org>
References: <cover.1296818921.git.segoon@openwall.com>
	<a6800dc8b0daed78256f98f52844cbbb48f4a76d.1296818921.git.segoon@openwall.com>
	<20110204124233.GB334@e-circ.dyndns.org>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kurt Van Dijck <kurt.van.dijck@eia.be>
Date: Fri, 4 Feb 2011 13:42:33 +0100

> On Fri, Feb 04, 2011 at 03:23:50PM +0300, Vasiliy Kulikov wrote:
>> Don't allow everybody to write to mb0_id file.
>> 
> very well!
> 
> Acked-by: Kurt Van Dijck <kurt.van.dijck@eia.be>

Applied.
