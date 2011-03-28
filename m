Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751740Ab1C1FAB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 01:00:01 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:46019 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750776Ab1C1FAA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 01:00:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=CG4s+VMsymFPpvoEvMtYOht3SLVOZygnQTvHPtyv9qjPdbTw3TraO3WsaA5XWqDTCy
         mI06oGfQp0g0jYnpLJUnx0xZdFXJGeMubw/i1o0rSyrD0qH5rEoWc5gEvJ2/wB3bBWXQ
         An8I9xAlc/qGWfWvScw+snsCpC0dmB5choTx8=
Date: Mon, 28 Mar 2011 12:59:37 +0800
From: Harry Wei <jiaweiwei.xiyou@gmail.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: wanlong.gao@gmail.com, linux-kernel@vger.kernel.org, greg@kroah.com
Subject: Re: [PATCH] Fixed the format: lines over 80 characters .
Message-ID: <20110328045935.GA2158@gmail.com>
Mail-Followup-To: Alexey Dobriyan <adobriyan@gmail.com>,
	wanlong.gao@gmail.com, linux-kernel@vger.kernel.org, greg@kroah.com
References: <1301195244-4606-1-git-send-email-wanlong.gao@gmail.com>
 <20110327125359.GA5816@p183.telecom.by>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110327125359.GA5816@p183.telecom.by>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 27, 2011 at 03:53:59PM +0300, Alexey Dobriyan wrote:
> On Sun, Mar 27, 2011 at 11:07:24AM +0800, wanlong.gao@gmail.com wrote:
> >     Lines over 80 characters
> > 
> >  Signed-off-by: Wanlong Gao <wanlong.gao@gmail.com>
Acked-by: Harry Wei <harryxiyou@gmail.com>
> NAK, this is less readable.
Hi Alexey,
	I don't know how above patch decreases the readable for us.
Well, we should recognize it may be less readable after cleaning the
lines, which are over 80 characters. But this is well for me.

> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
