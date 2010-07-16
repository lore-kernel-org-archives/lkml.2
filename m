Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935735Ab0GPHIE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 03:08:04 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:61879 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935690Ab0GPHH7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 03:07:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Kfhn6K9RMKsIgrX46BURfmOYIR+Y07zq07BGucF0eyHm4cJJ7t8guG/j7I5VwSVV71
         YBUVEd4rInBIZ1fjI/Vgc4tBhO4ZEosMMNO+jk9A8qMEV1Pkomn8z3XqL9f+QQ9eHmcs
         zusIotgfaZe/88iZ6DcLtoqe1Tcat/4OO83Qk=
Date: Fri, 16 Jul 2010 00:07:50 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Wan ZongShun <mcuos.com@gmail.com>
Cc: linux-input@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] touchscreen/nuc900: fix wrong setup_timer parameter
Message-ID: <20100716070750.GB3712@core.coreip.homeip.net>
References: <4C3FC736.4010805@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C3FC736.4010805@gmail.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 16, 2010 at 10:43:02AM +0800, Wan ZongShun wrote:
> Hi Dmitry,
> 
> This patch fixes wrong setup_timer parameter,when pen up event coming
> all codes quoting the w90p910_ts work failed.
> 

Applied, thanks Wan.

-- 
Dmitry
