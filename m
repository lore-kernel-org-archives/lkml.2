Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758597Ab0JFGTs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 02:19:48 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:51274 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758316Ab0JFGTq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 02:19:46 -0400
Date: Wed, 6 Oct 2010 09:19:27 +0300
From: Felipe Balbi <balbi@ti.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Greg KH <greg@kroah.com>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Joe Perches <joe@perches.com>, Jiri Kosina <jkosina@suse.cz>,
        Sergei Shtylyov <sshtylyov@ru.mvista.com>,
        "Balbi, Felipe" <balbi@ti.com>
Subject: Re: linux-next: manual merge of the usb tree with the trivial tree
Message-ID: <20101006061927.GA2659@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <20101006141414.abf7431f.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20101006141414.abf7431f.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 05, 2010 at 10:14:14PM -0500, Stephen Rothwell wrote:
>Hi Greg,
>
>Today's linux-next merge of the usb tree got a conflict in
>drivers/usb/musb/musb_gadget.c between commit
>7f26b3a7533bbc1ddd88b297c935ee4da8f74cea ("drivers/usb: Remove
>unnecessary return's from void functions") from the trivial tree and

funny that I wasn't CCed to that one :-(

-- 
balbi
