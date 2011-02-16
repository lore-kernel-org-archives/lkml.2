Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755481Ab1BPWvY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 17:51:24 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:36814 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753826Ab1BPWvS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 17:51:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=LHVsVj/n+tjTCNRDZkv8tyiuuh9RIM4NhHbSx+1kEWjSmkzQ4E+DWAHkZEAalGSF/4
         N5eCtvp4UDPRWCBKBQaTg7FytWHcXsf4H66m2us7QaFC6nPa7Uen9JwARlCYIif1dHOA
         0+/dooiNoJEJZ8+HUSkZAv27LGw4PQ0Ohj5/I=
Date: Wed, 16 Feb 2011 23:51:11 +0100
From: Tejun Heo <tj@kernel.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, David Rientjes <rientjes@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86, numa: seperate alloc_numa_distance from
 numa_reset_distance.
Message-ID: <20110216225111.GE29600@atj.dyndns.org>
References: <4D5C3A0F.3080107@kernel.org>
 <4D5C3A40.1060106@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D5C3A40.1060106@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 16, 2011 at 12:57:36PM -0800, Yinghai Lu wrote:
> 
> alloc code is much bigger the setting self.
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>

Again, the same thing.  It just depends.  Maybe it's slightly more
readable this way.  Still falls in the realm of bikeshedding.

--
tejun
