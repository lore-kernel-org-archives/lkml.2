Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754730Ab1KQAEF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 19:04:05 -0500
Received: from mail.vyatta.com ([76.74.103.46]:34537 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753962Ab1KQAEE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 19:04:04 -0500
Date: Wed, 16 Nov 2011 16:04:00 -0800
From: Stephen Hemminger <shemminger@vyatta.com>
To: Sven Joachim <svenjoac@gmx.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: sky2 driver breaks reboot/shutdown
Message-ID: <20111116160400.2dd0b3e9@nehalam.linuxnetplumber.net>
In-Reply-To: <87ehx8q9r0.fsf@turtle.gmx.de>
References: <87ehx8q9r0.fsf@turtle.gmx.de>
Organization: Vyatta
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Nov 2011 18:04:35 +0100
Sven Joachim <svenjoac@gmx.de> wrote:

> Hi,
> 
> after upgrading from Linux 3.1 to 3.2-rc2 I noticed that the kernel
> would no longer reboot or shutdown properly, hanging instead.  Removing
> the sky2 driver works around this.  According to "lspci -v", I have the
> following network card:
> 

Fix posted to netdev
