Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757952Ab1DHUzv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 16:55:51 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:57857 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753401Ab1DHUzu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 16:55:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=krzwTH/2DaphuYOV19vuyScydrqOySjz2C8eBOLJ0mZFc3tExJGeWBiASek2SwGvlv
         8b8y7NlNkVKXd2jblzhNWZzeogUj/u2lt8UQ7vVKP1jUjk+TSf1MheeONtj0PtpqWJBh
         0VchSP0YHi5/HqejwzkcB86+OHpnkVln5mbDQ=
Date: Fri, 8 Apr 2011 13:57:20 -0700
From: "Carlos R. Mafra" <crmafra@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
        wireless <linux-wireless@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Removal of staging/rt2860sta (and rt2870sta)
Message-ID: <20110408205720.GA16065@Pilar.site>
References: <4D9F2185.10108@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D9F2185.10108@lwfinger.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri,  8 Apr 2011 at  9:53:57 -0500, Larry Finger wrote:
> 
> I did the changes on my local git tree, committed them, and used
> 'git format-patch'. I expected that 'git rm' statements would be
> used to delete the files, but I got normal patch format. As a
> result, the resulting patch is over 2.4 GB, and has over 75,000
> lines. Obviously, I'm reluctant to dump a patch of this size on the
> lists. Is there a way to force git to use "rm" statements, or is
> there some way to handle this large patch?

I've just remembered about this patch in the git list, which I think
does what you want:

http://thread.gmane.org/gmane.comp.version-control.git/170537/focus=170581

