Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751817Ab0KVGYc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 01:24:32 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:37120 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751141Ab0KVGYa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 01:24:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Tu8LsG+LJMx5XLvDeLVnVFFuYvnGZbqJvK0Z/KyP+5VjiVDlHQQk9Mqct5lG7WbgDU
         /Wq7Lvrx7CbfekBXygHqmqM0ksSoxbvbW4jh2SbD+durHAxJ4PX19ukOf3nu5d7WcC9I
         Sd6MSlZRPAAe/f59yImoYXpZx3b7FstCyq2TI=
Date: Sun, 21 Nov 2010 22:24:21 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, linux-input@vger.kernel.org,
        Vojtech Pavlik <vojtech@ucw.cz>
Subject: Re: [RFC][PATCH] Input: ct82c710 - remove a redundant
 serio_register_port()
Message-ID: <20101122062421.GA31175@core.coreip.homeip.net>
References: <1290406007.6941.15.camel@mola>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1290406007.6941.15.camel@mola>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 22, 2010 at 02:06:47PM +0800, Axel Lin wrote:
> We already call serio_register_port() in ct82c710_probe(),
> thus remove a redundant serio_register_port() in ct82c710_init().
> 
> Looks like this bug is introduced by 
> 916d83cfe5da1cda454d8b0ae233f06b58bd7f91
> "Input: ct82c710 - convert to the new platform device interface"
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
> I don't have this hardware handy, I appreciate if someone can test this patch.
> 

I doubt anyone has; maybe I should start pruning older drivers...

BTW, the fix is obviously correct so I'll apply it and your other two
patches as well. Thanks Axel.

-- 
Dmitry
