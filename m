Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932727Ab1LEV5k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 16:57:40 -0500
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:47874 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932372Ab1LEV5j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 16:57:39 -0500
X-Sasl-enc: jiAcgISS+LXDzThqw8mI/QWEKh1VdEfC1qS7lveW/Xa7 1323122258
Date: Mon, 5 Dec 2011 13:56:52 -0800
From: Greg KH <greg@kroah.com>
To: "Wouter M. Koolen" <W.M.Koolen-Wijkstra@cwi.nl>
Cc: gregkh@suse.de, linux-usb@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [usb] kernel BUG at arch/x86/mm/physaddr.c:15
Message-ID: <20111205215652.GA17800@kroah.com>
References: <4ED8B66F.9020705@cwi.nl>
 <20111205203057.GA24674@kroah.com>
 <4EDD3CED.70705@cwi.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EDD3CED.70705@cwi.nl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 05, 2011 at 09:51:41PM +0000, Wouter M. Koolen wrote:
> Hi Greg,
> 
> Your patch seems to solve the issue. Rebooted six times, both hot
> and cold, and no crash.
> 
> Tested-by: Wouter M. Koolen <wmkoolen@cwi.nl>

Wonderful, thanks for testing, I'll queue it up soon.

greg k-h
