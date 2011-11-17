Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753950Ab1KQRwl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 12:52:41 -0500
Received: from oproxy5-pub.bluehost.com ([67.222.38.55]:42645 "HELO
	oproxy5-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752089Ab1KQRwj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 12:52:39 -0500
Message-ID: <4EC5496F.2080509@xenotime.net>
Date: Thu, 17 Nov 2011 09:50:39 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        "Gustavo F. Padovan" <padovan@profusion.mobi>,
        linux-bluetooth@vger.kernel.org
Subject: Re: linux-next: Tree for Nov 17 (bluetooth)
References: <20111117150733.a70faf2c9030d511d5367e1e@canb.auug.org.au>
In-Reply-To: <20111117150733.a70faf2c9030d511d5367e1e@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/16/2011 08:07 PM, Stephen Rothwell wrote:
> Hi all,


When CONFIG_BT_L2CAP is not enabled:

net/built-in.o: In function `hci_dev_open':
(.text+0xdce9a): undefined reference to `enable_hs'

-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
