Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752755Ab1CKIEO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 03:04:14 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:51944 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751770Ab1CKIEN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 03:04:13 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>
Subject: Re: [PATCH 2/2] tty: serial: Check UPF_FOURPORT, when CONFIG_SERIAL_8250_FOURPORT is defined
Date: Fri, 11 Mar 2011 09:04:03 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc6+; KDE/4.5.1; x86_64; ; )
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org
References: <1299822897-7047-1-git-send-email-nobuhiro.iwamatsu.yj@renesas.com> <1299822897-7047-2-git-send-email-nobuhiro.iwamatsu.yj@renesas.com>
In-Reply-To: <1299822897-7047-2-git-send-email-nobuhiro.iwamatsu.yj@renesas.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201103110904.03898.arnd@arndb.de>
X-Provags-ID: V02:K0:ynhMQHAZQ49NXLLE3KINJB3SB+9rhvdQFWLMnBOB2E7
 3Qamtqia3CfiAlC9vV0qoxvaL2ODDhwHTDzyRKTAusFwfMn9R7
 pmErYUtlEtHbflX7r2/wu26y3fQwXgxEqEvAE6VCSdqWTa4LuD
 SGXxaLFq0RligvyDBCq4GfwLsGVZ9BuEmaJ4KsNlAgHThahxt1
 YGCOTidCWc5LzFOAkcFAQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 11 March 2011 06:54:57 Nobuhiro Iwamatsu wrote:
> 
> When CONFIG_SERIAL_8250_FOURPORT is defined, driver uses UPF_FOURPORT in port.flags.
> Though CONFIG_SERIAL_8250_FOURPORT is not defined, there is a case to check UPF_FOURPORT.
> When CONFIG_SERIAL_8250_FOURPORT is defined only, this checks UPF_FOURPORT.
> 
> Signed-off-by: Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>

Looks good to me.

Acked-by: Arnd Bergmann <arnd@arndb.de>
