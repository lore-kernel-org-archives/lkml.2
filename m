Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933578Ab0D3Rr3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 13:47:29 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:54061 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933525Ab0D3Rpj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 13:45:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=JsyMd6rDiYPTHZ66cHiSsz2GDQAPgF2IzZi0Uxyk0Xa1fMgSbHzujOhYBB9h153rRN
         BQZP3DchNgCa7UD5S/AxOrkLmXSUNzy9xMr+pcwU5ycdNubFWaKSw6QGUeA7OIlTqEZ1
         N4oQyN3WROPTECAkg5CHsSIJq1BOIQQgPD7rY=
Date: Fri, 30 Apr 2010 21:45:34 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Bill Gatliff <bgat@billgatliff.com>,
       Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] of/gpio: Implement GPIOLIB notifier hooks
Message-ID: <20100430174534.GA31083@oksana.dev.rtsoft.ru>
References: <20100205203201.GA32281@oksana.dev.rtsoft.ru>
 <20100205203236.GC1475@oksana.dev.rtsoft.ru>
 <20100312130723.43308ccd.akpm@linux-foundation.org>
 <fa686aa41003121338oe34eb89o22177cb0a309cc85@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <fa686aa41003121338oe34eb89o22177cb0a309cc85@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 12, 2010 at 02:38:02PM -0700, Grant Likely wrote:
[...]
> How to proceed:  I'd like to leave this series out for the 2.6.34
> cycle and I'll pick it into my OF tree before the 2.6.35 merge window,
> but I'll probably modify it to call the OF hooks directly and leave
> out the unnecessary notifier infrastructure.

Ping?
