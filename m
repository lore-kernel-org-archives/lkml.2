Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934807Ab0EEQYi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 12:24:38 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:38691 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934535Ab0EEQYg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 12:24:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=uig+hnHqQEDEBBFbUeFbw7ZD4OTUyP99tGKWZ6VduNvz9v8cjVVPBneEM4aGgwycNr
         rk8Ezr3ceES68gL6FP8VHSYeSWkZhxcrTmtcq0XLZ1PYsP+4FM6L6toGlIXos/Bq5Y+C
         c2YiZ/kqHojJjQeAf0LARxhFZBB+rdQyzGyYs=
Date: Wed, 5 May 2010 09:24:24 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Damjan Jovanovic <damjan.jov@gmail.com>
Cc: Alessandro Rubini <rubini@cvml.unipv.it>, linux-kernel@vger.kernel.org,
       linux-input@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH] input: handle bad parity PS/2 packets in mouse drivers
 better
Message-ID: <20100505162424.GA6330@core.coreip.homeip.net>
References: <r2x9e89675b1004080434yfea09b06x2c3c4680a9437a9@mail.gmail.com>
 <g2v9e89675b1004130429w6f6f9775u2e34d4727de706e@mail.gmail.com>
 <20100414205959.GB11838@core.coreip.homeip.net>
 <m2k9e89675b1004170233yb5ab19ach1713ccbee001883e@mail.gmail.com>
 <g2u9e89675b1005030431wec92e4bdq9af9149a839a638e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <g2u9e89675b1005030431wec92e4bdq9af9149a839a638e@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 03, 2010 at 01:31:13PM +0200, Damjan Jovanovic wrote:
> Ping? This patch works, can you please commit it?
> 

The patch has been pulled into mainline. Thank you for your efforts and
persistence.

-- 
Dmitry
