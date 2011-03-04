Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759412Ab1CDNv4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 08:51:56 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:51132 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751911Ab1CDNvz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 08:51:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=uNLbDhRSPvby3R3uc4RZGd+7E8h/h5eSFv4HI7qstmNJoEOe6L5m58uEktPrN53PgU
         Q/R83foX5d6PItyt7zWVd4uR/aeQYcuK7ahQOrPp8vXb8jADUp0iNRjcUYyXQt4ju1BE
         msT1Dg4R/9rsjJ/kfqANgpdE2KIGTT9rdRtCE=
Date: Fri, 4 Mar 2011 14:51:45 +0100
From: Tejun Heo <tj@kernel.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, David Rientjes <rientjes@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH for .39] x86, numa: Fix numa_emulation code with node0
 without RAM
Message-ID: <20110304135145.GO20499@htj.dyndns.org>
References: <4D6ED045.3090309@kernel.org>
 <20110304110401.GI20499@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110304110401.GI20499@htj.dyndns.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 04, 2011 at 12:04:01PM +0100, Tejun Heo wrote:
> > Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> 
> Acked-by: Tejun Heo <tj@kernel.org>

The Acked-by was for the other patch for .38.  I applied this one to
x86/mm.

Thanks.

-- 
tejun
