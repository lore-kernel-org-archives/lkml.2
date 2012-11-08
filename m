Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964901Ab2KHVEd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 16:04:33 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:60605 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964797Ab2KHVEb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 16:04:31 -0500
Message-ID: <509C1E5C.3060306@wwwdotorg.org>
Date: Thu, 08 Nov 2012 14:04:28 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Russell King <linux@arm.linux.org.uk>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, John Stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>
CC: linux-arch@vger.kernel.org, Stephen Warren <swarren@nvidia.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ARM: delete struct sys_timer
References: <1352408516-21988-1-git-send-email-swarren@wwwdotorg.org> <1352408516-21988-2-git-send-email-swarren@wwwdotorg.org>
In-Reply-To: <1352408516-21988-2-git-send-email-swarren@wwwdotorg.org>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/08/2012 02:01 PM, Stephen Warren wrote:
> Now that the only field in struct sys_timer is .init, delete the struct,
> and replace the machine descriptor .timer field with the initialization
> function itself.

Oops. This one patch is a duplicate of 11/11 in the series I just sent.
Sorry.
