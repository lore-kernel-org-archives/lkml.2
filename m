Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752243Ab2GJCkw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 22:40:52 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:61167 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750934Ab2GJCkv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 22:40:51 -0400
Date: Mon, 9 Jul 2012 22:40:47 -0400
From: Kevin McKinney <klmckinney1@gmail.com>
To: Marcos Paulo de Souza <marcos.souza.org@gmail.com>, klmckinney1@gmail.com
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, dan.carpenter@oracle.com,
        standby24x7@gmail.com
Subject: Re: [PATCH 0/3] staging: bcm: Cleanup bcm driver
Message-ID: <20120710024046.GA8894@gmail.com>
References: <1341883960-21635-1-git-send-email-marcos.souza.org@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1341883960-21635-1-git-send-email-marcos.souza.org@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 09, 2012 at 10:32:37PM -0300, Marcos Paulo de Souza wrote:
> Hi Kernel guys!
>    
> This new patchset tries to clean a little the bcm driver, removing
> some unused macros and some dead code.
>   
> These macros and dead code were reported by the forgotten-macros tool
> (https://github.com/marcosps/forgotten_macros).
>   
> The tool is under development, but all the patches looks like OK.       
>                                
> This patchset is based in staging-next.
>   
> Thanks guys!

The patchset looks good!

Thanks,
Kevin
