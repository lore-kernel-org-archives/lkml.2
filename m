Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932205Ab1DFWHN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 18:07:13 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:64116 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932117Ab1DFWHI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 18:07:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=pPMkvf4K+aoS9aEwCn3uiGN8XZACwUNMkxH4FsB6s+FcRa/xMLvVJz82gF8ZL4/3S+
         F24tcgo1yaotiwxrnoxKaTxTFV4ll2bnDILBIjr0VmfMRElhXncp9+Kau+3fN4yar0uy
         UlLAAQ9QpAHdgRLpndYoKmowCylo1k8Yy0gew=
Date: Wed, 6 Apr 2011 15:07:01 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Chase Douglas <chase.douglas@canonical.com>
Cc: Henrik Rydberg <rydberg@euromail.se>,
        Peter Hutterer <peter.hutterer@who-t.net>,
        Nikolai Kondrashov <spbnick@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Chris Bagwell <chris@cnpbagwell.com>
Subject: Re: [PATCH v4] Documentation: Add evdev type and code definitions
Message-ID: <20110406220701.GA11611@core.coreip.homeip.net>
References: <1302121172-16703-1-git-send-email-chase.douglas@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1302121172-16703-1-git-send-email-chase.douglas@canonical.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chase,

On Wed, Apr 06, 2011 at 04:19:31PM -0400, Chase Douglas wrote:
> This commit adds the file Documentation/input/evdev-codes.txt.
> 
> Cc: Henrik Rydberg <rydberg@euromail.se>
> Cc: Peter Hutterer <peter.hutterer@who-t.net>
> Cc: Nikolai Kondrashov <spbnick@gmail.com>
> Cc: linux-input@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Acked-by: Henrik Rydberg <rydberg@euromail.se>
> Signed-off-by: Chase Douglas <chase.douglas@canonical.com>
> Signed-off-by: Chris Bagwell <chris@cnpbagwell.com>

Thank you very much for doing this. I am very happy with the state of
document at the moment and I want to apply it and get in .39.

The only 2 changes I'd like (I'll do them on my side) is renaming the
file from evdev-codes to event-codes and evdev protocol to input
protocol since the data applicable not only to evdev but to entire input
core.

Thanks.

-- 
Dmitry
