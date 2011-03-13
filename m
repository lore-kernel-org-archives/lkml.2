Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754816Ab1CME0G (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Mar 2011 23:26:06 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:53149 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754248Ab1CME0B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Mar 2011 23:26:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=nmT9R4z1s7i4iFpBbCBesmtSf2seC0Q6stso/RPqvJRAXb4UnwLgjoMcumjRvDAPY1
         rVWWUtbLi/CPYqubPfVn6bfrhV7PxeCIXnHPnHtE3mO7dtYYyCo0Q8tyjJokobpEyMjY
         qFofYST2xuSqhCVGeAE4v0EHta1MlHYwB5Qrs=
Date: Sat, 12 Mar 2011 20:25:56 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Henrik Rydberg <rydberg@euromail.se>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] hid-input: Keyboard and MT support for MacBookPro8
Message-ID: <20110313042556.GB17351@core.coreip.homeip.net>
References: <1299869123-18346-1-git-send-email-rydberg@euromail.se>
 <alpine.LNX.2.00.1103120001020.19969@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1103120001020.19969@pobox.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 12, 2011 at 12:02:05AM +0100, Jiri Kosina wrote:
> On Fri, 11 Mar 2011, Henrik Rydberg wrote:
> 
> > Hi Jiri, Dmitry,
> > 
> > Keyboard and MT support for the new MacBookPro models. The first patch
> > is against HID, the second against Input. As usual, they need to be
> > synced.
> > 
> > The patches have been tested on the Ubuntu forums, many thanks to Andy
> > for the nice patches.
> 
> Thanks a lot Henrik for relaying those patches.
> 
> Dmitry, what tree would you prefer these patches to go through? I am fine 
> either way, and
> 
> 	Signed-off-by: Jiri Kosina <jkosina@suse.cz>
> 
> for the HID changes.

I'll grab it then, thank you.

-- 
Dmitry
