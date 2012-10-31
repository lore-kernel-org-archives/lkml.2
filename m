Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760816Ab2JaVjH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 17:39:07 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:58395 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756386Ab2JaVjE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 17:39:04 -0400
Date: Wed, 31 Oct 2012 14:38:59 -0700
From: Tejun Heo <tj@kernel.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Input: introduce managed input devices (add devres
 support)
Message-ID: <20121031213859.GB2945@htj.dyndns.org>
References: <20121023053513.GA15642@core.coreip.homeip.net>
 <20121031210532.GX2945@htj.dyndns.org>
 <5132958.JXBGbd4rj1@dtor-d630.eng.vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5132958.JXBGbd4rj1@dtor-d630.eng.vmware.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Dmitry.

On Wed, Oct 31, 2012 at 02:37:01PM -0700, Dmitry Torokhov wrote:
> Not all drivers use devres for rest of their resources so it makes sense
> to have unmanaged versions (like we have request_irq/devm_request_irq).
> Besides:
> 
> [dtor@dtor-ws vmci]$ grep -r input_allocate_device drivers/ | wc -l
> 298
> 
> so I'd rather not ;)

Whee... didn't know there were that many.

Thanks.

-- 
tejun
