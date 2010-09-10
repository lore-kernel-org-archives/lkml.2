Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755244Ab0IJXWU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 19:22:20 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:55315 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754971Ab0IJXWS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 19:22:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=q0EtuoEvfvjc3PdnheXL38tlaJbGIXz4scEwIdFDc/mD9sgXIMVEs94kr1kxf9Ud5O
         Hrak4Pl5lvkC+IPY3sCG7OZYvMbVspyP8hqMOIFoJBFQN8V2qvyKlCNhhdyopYdqvlP1
         r8v6WFkToLX1Bg5tYmzUxQLN2axQIIgTNncNw=
Date: Sat, 11 Sep 2010 01:24:07 +0200
From: Lutz Ballaschke <vegan.grindcore@googlemail.com>
To: Wim Van Sebroeck <wim@iguana.be>
Cc: me@mortis.eu, linux-watchdog@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] watchdog: add f71862fg support
Message-ID: <20100910232407.GA13116@kreios.titan>
References: <20100906132434.GA17730@kreios.titan> <20100907131837.GH6114@salidar.me.mortis.eu> <20100910090301.GS354@infomag.iguana.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100910090301.GS354@infomag.iguana.be>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 10, 2010 at 11:03:01AM +0200, Wim Van Sebroeck wrote:
> 
> > Given that the F71862 has *two* pins assignable to the WDTRST# signal,
> > please document that fact, and the reason for choosing this one in the
> > code.
> > 
> > Perhaps it might even be desirable to insert a printk there.  This to
> > make the user aware of the fact that this driver might not work if the
> > pin configuration of their hardware doesn't match the assumption you
> > make about it in this code.
> 
> I propose to Document it in the code and add a module-parameter so that it is selectable.
>
I agree. I will post the patch again (missing parts will follow soon). 
I placed printk in watchdog_start(). Since this means printk output 
everytime /dev/watchdog is opened I'm not sure whether i like it there. 
Maybe it fits better in f71808e_find(). But this would require
additional if / else and stuff. 

Regards,
Lutz Ballaschke
