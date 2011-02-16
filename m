Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755413Ab1BPWtb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 17:49:31 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:61371 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751506Ab1BPWt3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 17:49:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Ryd4UKjdJvirahUwHj6TijmLHv1E2B6gIZFwOPQHZn/IO49okG+egukaH7wNIf9fZi
         V8ZIZnZ7lAo3VrbCvaHJpqjMqw+JN2i712E7YYJ90aPr5IquU+waP7Z3ZqHZWLKkiAv5
         NZdP9+0bqdgIHyyU1XpMR3uMlT0bJJpG14Qdw=
Date: Wed, 16 Feb 2011 23:49:22 +0100
From: Tejun Heo <tj@kernel.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, David Rientjes <rientjes@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86, numa: cleanup x86_acpi_numa_init()
Message-ID: <20110216224922.GD29600@atj.dyndns.org>
References: <4D5C3A0F.3080107@kernel.org>
 <4D5C5046.1030903@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D5C5046.1030903@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 16, 2011 at 02:31:34PM -0800, Yinghai Lu wrote:
> make it more readable. put valid checking together.
> 
> Also restore old acpi_numa_init(). we don't need to touch it
> because already have x86 own wrapper.
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>

What's the point of this patch?  If someone else likes it, I don't
object but I have no idea why this is any better than before.

--
tejun
