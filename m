Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753829Ab1K1RR6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 12:17:58 -0500
Received: from oproxy4-pub.bluehost.com ([69.89.21.11]:60428 "HELO
	oproxy4-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753679Ab1K1RR4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 12:17:56 -0500
Message-ID: <4ED3CFF7.9090502@xenotime.net>
Date: Mon, 28 Nov 2011 10:16:23 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>, Paul Moore <paul@paul-moore.com>
Subject: Re: linux-next: Tree for Nov 28 (netlabel)
References: <20111128162556.47758629406b638a99428049@canb.auug.org.au>
In-Reply-To: <20111128162556.47758629406b638a99428049@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/27/2011 09:25 PM, Stephen Rothwell wrote:
> Hi all,
> 
> Changes since 20111125:

When IPV6 is not enabled:

net/netlabel/netlabel_kapi.c: In function 'netlbl_cfg_unlbl_map_add':
net/netlabel/netlabel_kapi.c:165:4: error: implicit declaration of function 'netlbl_af6list_add'


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
