Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757829Ab2AEDMg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 22:12:36 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:55018 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752763Ab2AEDMd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 22:12:33 -0500
Message-ID: <4F05151D.5070401@lwfinger.net>
Date: Wed, 04 Jan 2012 21:12:29 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111220 Thunderbird/9.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: "John W. Linville" <linville@tuxdriver.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: linux-next: manual merge of the wireless-next tree with the net-next
 tree
References: <20120105140405.92816482d364abfcf3854d74@canb.auug.org.au>
In-Reply-To: <20120105140405.92816482d364abfcf3854d74@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/04/2012 09:04 PM, Stephen Rothwell wrote:
> Hi John,
>
> Today's linux-next merge of the wireless-next tree got a conflict in
> drivers/net/wireless/b43legacy/dma.c between commit 3db1cd5c05f3 ("net:
> fix assignment of 0/1 to bool variables") from the net-next tree and
> commit 5d07a3d62f63 ("b43legacy: Avoid packet losses in the dma worker
> code") from the wireless-next tree.
>
> Just context changes.  I fixed it up (see below) and can carry the fix as
> necessary.

Is there a good explanation why changes in wireless drivers are sent to 
net-next, and not wireless-testing? If that were stopped, this kind of conflict 
would be avoided.

Larry

