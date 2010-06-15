Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758464Ab0FOU52 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 16:57:28 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:46033 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757676Ab0FOU51 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 16:57:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=QBY5VYDgVx153go6UZqwqsSo/HAE1yc4yk0X1JabPRQzDwQkkBvXCWcMDAG8tcK5Kn
         AP966zU4yl3no7FJuUNEEwSBmMoB6BpHNp5CyUt1f3+tv7LgsmXsUOooQCE7QE5Q/lSm
         +5RhgpZFEnsv/3yExHa0AK7sDC2LtP+F5y4pU=
Subject: Re: [Nouveau] [BUG ?] Nouveau driver on 330M GT
From: Ben Skeggs <skeggsb@gmail.com>
Reply-To: skeggsb@gmail.com
To: Eric Lacombe <goretux@gmail.com>
Cc: Younes Manton <younes.m@gmail.com>, Dave Airlie <airlied@linux.ie>,
       nouveau@lists.freedesktop.org, linux-kernel@vger.kernel.org
In-Reply-To: <201006151506.27154.goretux@gmail.com>
References: <201006111052.29187.goretux@gmail.com>
	 <201006151318.08619.goretux@gmail.com> <1276601463.2526.4.camel@nisroch>
	 <201006151506.27154.goretux@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 16 Jun 2010 06:58:25 +1000
Message-ID: <1276635505.14136.1.camel@araqiel>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 (2.30.1.2-7.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-06-15 at 15:06 +0200, Eric Lacombe wrote:
> > Is this a system with switchable graphics (Optimus probably)?  If so,
> > fiddle with your BIOS options and try and enable only the NVIDIA board.
> 
> oops, my fault... I forgot to switch to the nvidia chip (my laptop is a sony 
> vaio Z11Z9E) with the button. Here the new drm logs with a 2.6.35-rc2 kernel :
Aah, yep, that's much better.  I've seen what I believe to be a similar
issue reported, but other things have prevented me looking at it
properly yet.

I'm on holidays for the next 2 weeks, but I'll get back to looking at it
then.  The only suggestion so far is to make sure you're using the very
latest code from nouveau git, just to make sure it's not already
fixed :)

Ben.

