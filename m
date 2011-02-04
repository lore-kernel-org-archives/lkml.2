Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751954Ab1BDRjB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 12:39:01 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:55773 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751083Ab1BDRi7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 12:38:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=GQitzFa+gw4vY2IuAKbNxyx8ZgTR9MFx+TfAUPOFfXAFeFZbO75ouIbGmRaX4k/ePp
         V/lnYZFvFA7TBaWzpr09LE3E1w9aMElOWNKcC8jF1jkpujHTbqrTyf1ilRiJKcJoOsle
         7pWY79SVvX/To19MRsvqN38PjtPHzKfgjDVlM=
Date: Fri, 4 Feb 2011 18:38:55 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [PATCH] [0/139] 2.6.35.11 longterm review
Message-ID: <20110204173853.GC1808@nowhere>
References: <20110201443.618138584@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110201443.618138584@firstfloor.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andi,

On Tue, Feb 01, 2011 at 04:43:13PM -0800, Andi Kleen wrote:
> 
> This is the start of the longterm review cycle for the 2.6.35.10 release.
> There are a large number of patches in this series, all will be posted as a 
> response to this one.  If anyone has any issues with these being applied, 
> please let me know.  If anyone is a maintainer of the proper subsystem, and
> wants to add a Signed-off-by: line to the patch, please respond with it.
> 
> The full quilt queue can be found at
> git://git.kernel.org/pub/scm/linux/kernel/git/longterm/longterm-queue-2.6.35
> 
> Responses should be made within 48 hours.

Oops, it might be too late then.

But just in case it's not, could you please also include this:

https://patchwork.kernel.org/patch/469201/

Thanks!
