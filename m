Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754394Ab2F1TlU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 15:41:20 -0400
Received: from violet.fr.zoreil.com ([92.243.8.30]:37774 "EHLO
	violet.fr.zoreil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753128Ab2F1TlT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 15:41:19 -0400
Date: Thu, 28 Jun 2012 21:30:26 +0200
From: Francois Romieu <romieu@fr.zoreil.com>
To: Nix <nix@esperi.org.uk>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: 3.4.x regression: rtl8169: frequent resets
Message-ID: <20120628193026.GA31627@electric-eye.fr.zoreil.com>
References: <87y5n7qup0.fsf@spindle.srvr.nix>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87y5n7qup0.fsf@spindle.srvr.nix>
User-Agent: Mutt/1.4.2.2i
X-Organisation: Land of Sunshine Inc.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nix <nix@esperi.org.uk> :
> I recently upgraded from 3.3.x to 3.4.4, and am now experiencing
> networking problems with my desktop box's r8169 card. The symptoms are
> that all traffic ceases for five to ten seconds, then the card appears
> to reset and everything is back to normal -- until it happens again. It
> can happen quite a lot:

Can you try and revert 036dafa28da1e2565a8529de2ae663c37b7a0060 ?

I would welcome a complete dmesg including the XID line from the
r8169 driver.

Thanks.

-- 
Ueimor
