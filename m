Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761249Ab1EAQ7S (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 May 2011 12:59:18 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:62485 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755209Ab1EAQ7Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 May 2011 12:59:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=eCnA3OjLGA4LCvVKy5uUhSriegIGpnE1nTwfFMU/KW97lun73ANCdbIpOVmpFMnQlG
         /2RaKIN/16SWseqzpLPJTLkOqo89Lzy7rUMTk9ryyHxlB3OLhSYAkaWxdtx+ELb7IU7b
         cl81duHhMQ6cIw5Z6S/lH+Uy8iT0jSvJSsX1w=
Date: Sun, 1 May 2011 09:50:58 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: Re: [PATCH] Input: h3600_ts_input - bugfix for
 request_irq()/free_irq() parameters
Message-ID: <20110501165058.GA23240@core.coreip.homeip.net>
References: <1302698231.3002.4.camel@phoenix>
 <20110428162620.GA9529@core.coreip.homeip.net>
 <BANLkTi=BpdfE+VmBZuzaodNiE9JUhARbfg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTi=BpdfE+VmBZuzaodNiE9JUhARbfg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 02, 2011 at 12:23:43AM +0800, Axel Lin wrote:
> Hi Dmitry,
> 
> 2011/4/29 Dmitry Torokhov <dmitry.torokhov@gmail.com>:
> > On Wed, Apr 13, 2011 at 08:37:11PM +0800, Axel Lin wrote:
> >> The dev field of h3600_dev is a pointer, thus use ts->dev instead of &ts->dev
> >> as the dev_id argument while calling request_irq()/free_irq().
> >
> > dev_id does not need to have specific type, it is just a cookie so as
> > long as it's value is unique we are OK. &ts->dev works as well as
> > ts->dev.
> 
> Then you might want to apply below patch:
> http://www.spinics.net/lists/linux-input/msg15042.html
> 
> My original intension was to fix the irq driver data mismatch.
> 

Ah, I see. Then I'll apply it but with teh above as commit message.

-- 
Dmitry
