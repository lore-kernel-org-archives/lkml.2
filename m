Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752139Ab0FDGei (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 02:34:38 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:57616 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750775Ab0FDGeg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 02:34:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=RuUi+NdIl+un6PahniV1cqCV/XgyK3dZRxXV/AcdqN0MzHKIoPmZwtNrZ6VtdKi1R6
         i4U+4nmoyPAMeqvJtzZ+/iBbmW2yvz8Arjfqji1Cypv6qZ0kI0PQWnccXky3guCfLhGo
         O2psvzCKIa+dKbWMD0ZRXCV3Bzmj9xL2lEEtU=
Date: Thu, 3 Jun 2010 23:34:30 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jiri Kosina <jkosina@suse.cz>, Mika Kuoppala <mika.kuoppala@nokia.com>,
       Benjamin Tissoires <tissoire@cena.fr>, Rafi Rubin <rafi@seas.upenn.edu>
Subject: Re: [PATCH 4/4] input: Use driver hint to compute the evdev buffer
 size
Message-ID: <20100604063429.GB21239@core.coreip.homeip.net>
References: <1275552062-8153-1-git-send-email-rydberg@euromail.se>
 <1275552062-8153-2-git-send-email-rydberg@euromail.se>
 <1275552062-8153-3-git-send-email-rydberg@euromail.se>
 <1275552062-8153-4-git-send-email-rydberg@euromail.se>
 <1275552062-8153-5-git-send-email-rydberg@euromail.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1275552062-8153-5-git-send-email-rydberg@euromail.se>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Henrik,

On Thu, Jun 03, 2010 at 10:01:02AM +0200, Henrik Rydberg wrote:
>  
> +static inline void input_set_events_per_packet(struct input_dev *dev, int nev)

A kerneldoc-style comment explaining the purpose of the new function would
be very beneficial.

> +{
> +	dev->hint_events_per_packet = nev;
> +}
> +

Thanks.

-- 
Dmitry
