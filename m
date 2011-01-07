Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752429Ab1AGUnh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 15:43:37 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:59621 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751557Ab1AGUng (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 15:43:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=x7OwgkUUwl6FvuVh3tzv4DudUkpGe+ntOskSxRtVfLQGz51piB3nvVbXjVmkWtEehk
         +5JmFYfnb5GZiszOdREOcmd4zoI2ucUrXRLLnWC8gr2IkRpvmADwavIzvD32XsGW8ckp
         t8mjn9nfCHrmvRUzkz4y9YPgXF+DDip+prPTc=
Date: Fri, 7 Jan 2011 15:43:32 -0500
From: Tejun Heo <tj@kernel.org>
To: David Rientjes <rientjes@google.com>
Cc: Jan Beulich <JBeulich@novell.com>, Ingo Molnar <mingo@elte.hu>,
        tglx@linutronix.de, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: unify "numa=" command line option handling
Message-ID: <20110107204332.GE7355@mtj.dyndns.org>
References: <4D2603BF020000780002ACA7@vpn.id2.novell.com>
 <alpine.DEB.2.00.1101061235010.30820@chino.kir.corp.google.com>
 <20110107203304.GC7355@mtj.dyndns.org>
 <alpine.DEB.2.00.1101071234590.31653@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1101071234590.31653@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 07, 2011 at 12:36:41PM -0800, David Rientjes wrote:
> I don't think it applies cleanly anymore since d906f0eb was merged, but I 
> agree with Jan that this new feature should probably be merged for .38.

Okay, the series is already too late for this merge window at this
point anyway.  I'm not too happy how the merge process is progressing
but, well, it seems there needs to be another refresh.  Anyways,
please let me know when the series needs to be refreshed.

Thanks.

-- 
tejun
