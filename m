Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753242Ab1DCXUG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Apr 2011 19:20:06 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:50158 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751821Ab1DCXUF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Apr 2011 19:20:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=xqXy73stNcrm1qDX7Wd4U9WmaP94CfD5WpguaHMBN41iX3F1YsedIhNCZlfOZD1ih9
         q819mSdrh3jLELT3mR0ntjDP3hkOaZm/vM72jtCFAsxvmS/BNSjHATJZQrVyP6xy25In
         ZrgEf/SWEGsaXCHKUESeLjIIkdeIlX69GWy9k=
Date: Sun, 3 Apr 2011 16:20:00 -0700
From: Tejun Heo <tj@kernel.org>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Florian Mickler <florian@mickler.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, David Rientjes <rientjes@google.com>
Subject: Re: [PATCH] x86, numa_64: remove unused variable
Message-ID: <20110403232000.GA1420@mtj.dyndns.org>
References: <1301843624-22364-1-git-send-email-florian@mickler.org>
 <4D989175.9090400@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D989175.9090400@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 03, 2011 at 07:25:41PM +0400, Cyrill Gorcunov wrote:
> On 04/03/2011 07:13 PM, Florian Mickler wrote:
> > In case !CONFIG_ACPI_NUMA and !CONFIG_AMD_NUMA gcc emits a warning about
> > the unused variable ret.
> > 
> > As that variable is in fact not needed I choose to remove it.
> > 
> > Signed-off-by: Florian Mickler <florian@mickler.org>
> > ---
> >  arch/x86/mm/numa_64.c |    8 ++------
> >  1 files changed, 2 insertions(+), 6 deletions(-)
> > 
> 
> As far as I remember David prefer to have 'ret' in place but since it causes
> such a warn we better to drop it.

Applied to x86-mm.  Thanks for the cc Cyrill.

-- 
tejun
