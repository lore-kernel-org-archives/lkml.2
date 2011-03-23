Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752372Ab1CWVU7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 17:20:59 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:58114 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751065Ab1CWVU6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 17:20:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=hsnZ9yiXPF+m4XYnuVdd1rifvUscUGLK1RAdoLx6aB/Kc8EYAdH4MNuYYR1r998G7S
         jNeJcNSh9Q74oOF/TOvbRe0CeTx2IJWrYHWCnmBxDSK6gIfEDh7NNGAp/yJiEJdsSKi5
         rxjOLIB9h2FK26GMjAOJzUwSRnT+HstJaosmE=
Message-ID: <4D8A5AE1.5090904@gmail.com>
Date: Wed, 23 Mar 2011 23:41:05 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110223 Thunderbird/3.1.8
MIME-Version: 1.0
To: Don Zickus <dzickus@redhat.com>
CC: Jack Steiner <steiner@sgi.com>, Ingo Molnar <mingo@elte.hu>,
        tglx@linutronix.de, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Robert Richter <robert.richter@amd.com>
Subject: Re: [PATCH] x86, UV: Fix NMI handler for UV platforms
References: <4D877C4B.9090602@gmail.com> <20110321175110.GL1239@redhat.com> <20110321182235.GA14562@sgi.com> <20110321193740.GN1239@redhat.com> <20110322171118.GA6294@sgi.com> <20110322184450.GU1239@redhat.com> <20110322212519.GA12076@sgi.com> <20110322220505.GB13453@redhat.com> <20110323163255.GA17178@sgi.com> <20110323175320.GB9413@redhat.com> <20110323200008.GZ1239@redhat.com>
In-Reply-To: <20110323200008.GZ1239@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/23/2011 11:00 PM, Don Zickus wrote:
> On Wed, Mar 23, 2011 at 01:53:20PM -0400, Don Zickus wrote:
>> Let me know if the patch fixes that problem.  Then it will be one less
>> thing to worry about. :-)
> 
> Ok, I was an idiot and made the patch against RHEL-6.  Here is the one
> against 2.6.38.  Sorry about that.
> 
> Cheers,
> Don
> 

Interesting. (CC'ing Robert)

-- 
    Cyrill
