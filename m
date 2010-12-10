Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756093Ab0LJSwU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 13:52:20 -0500
Received: from mail-gx0-f180.google.com ([209.85.161.180]:49229 "EHLO
	mail-gx0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753841Ab0LJSwS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 13:52:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=iJUJwO5cdIAz8QXzvO3b/G3zGxX31rDjH8vDzyxSDPDGESkiClVjvuZOYKURyzfzd9
         7t2XjTSiezF20QRoN/w66OSJZMVEUOwCDTDeqPCGDGQnFjd7yst9A3EmLETqoOoa6Qzd
         vwJW35JLK7UWWSeb3zNppetO9wKYqp9ZEtGzo=
Date: Fri, 10 Dec 2010 10:52:12 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Ping Cheng <pinglinux@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] input: mt: Interface and MT_TOOL documentation updates
Message-ID: <20101210185211.GD1630@core.coreip.homeip.net>
References: <1291929732-5989-1-git-send-email-rydberg@euromail.se>
 <AANLkTi=mqMY_VG=0RdN5O0fDh6wpTRb5Z59L6440hvX6@mail.gmail.com>
 <4D026DB1.8070100@euromail.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D026DB1.8070100@euromail.se>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 10, 2010 at 07:13:05PM +0100, Henrik Rydberg wrote:
> >
> 
> > Can we make MT_TOOL_ENVELOPE cover a bit more cases by:
> > 
> > 1. Removing ", and is only used for legacy hardware";
> > 2. Adding "Or the number of contacts inside the bounding rectangle is
> > reported if hardware provides the number but not the real contact
> > positions" to the end of the paragraph.
> 
> 
> You might disagree, but "old" is still somewhat apt in this situation. How would
> you suggest we report the number of fingers?
> 

BTN_TOOL_xxxTAP I guess...

-- 
Dmitry
