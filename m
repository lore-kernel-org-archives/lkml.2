Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751327Ab0K1CBv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Nov 2010 21:01:51 -0500
Received: from smtp-out.google.com ([216.239.44.51]:21045 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750830Ab0K1CBu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Nov 2010 21:01:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=U7wqQ2l1HCl2oGExv32R/OsE4WLku83sLcEJID9KXzgkUmETY3/ShvrVVsT578zf6i
         LdnhSaHvlSMv97c/tLfA==
Date: Sat, 27 Nov 2010 18:01:45 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Shaohui Zheng <shaohui.zheng@intel.com>
cc: akpm@linux-foundation.org, gregkh@suse.de, mingo@redhat.com, hpa@zytor.com,
        tglx@linutronix.de, lethal@linux-sh.org, ak@linux.intel.com,
        yinghai@kernel.org, randy.dunlap@oracle.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org,
        haicheng.li@intel.com, haicheng.li@linux.intel.com,
        shaohui.zheng@linux.intel.com
Subject: Re: [patch 2/2] mm: add node hotplug emulation
In-Reply-To: <20101124064516.GA6777@shaohui>
Message-ID: <alpine.DEB.2.00.1011271800240.3764@chino.kir.corp.google.com>
References: <A24AE1FFE7AEC5489F83450EE98351BF28723FC4A7@shsmsx502.ccr.corp.intel.com> <20101122014706.GB9081@shaohui> <20101124064516.GA6777@shaohui>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Nov 2010, Shaohui Zheng wrote:

> ah, a long time silence.
> 

Sorry, last week included a holiday in the USA.

> Does somebody know the status of this patch, is it accepted by the maintainer?
> I am not in patch's CC list, so I will not get mail notice when the patch was
> accepted by the maintainer.
> 

Neither of these patches have been merged anywhere yet, you're not missing 
anything :)  If/when Andrew picks it up, I'm quite certain he'll cc you on 
it.
