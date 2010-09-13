Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754655Ab0IMIzX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 04:55:23 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:54980 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754259Ab0IMIzV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 04:55:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=q7mwqCZoDeAfsZ+UATTquCyBBsYEypruBEMrd+YN1mQv+rJ/ZnUuhjGsvDNlvvd/PJ
         /sakHCq5rkiim5sarGsbu59fFK8Myh4IsI6ULMjdCh3wrfOWXdfyGiw0ECa1K1zINVc5
         wXJXluv+ceXUlD93yB7LnjXcV/GaFkAfJWLkY=
Date: Mon, 13 Sep 2010 12:55:16 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Don Zickus <dzickus@redhat.com>, mingo@elte.hu, robert.richter@amd.com,
        fweisbec@gmail.com, linux-kernel@vger.kernel.org, ying.huang@intel.com,
        ming.m.lin@intel.com, yinghai@kernel.org, andi@firstfloor.org,
        eranian@google.com
Subject: Re: [PATCH 0/3 v2] nmi perf fixes
Message-ID: <20100913085515.GC5728@lenovo>
References: <1283454469-1909-1-git-send-email-dzickus@redhat.com> <1284118900.402.35.camel@laptop> <1284125693.402.58.camel@laptop> <1284126770.402.60.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1284126770.402.60.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 10, 2010 at 03:52:50PM +0200, Peter Zijlstra wrote:
... 
> That seems to be clear enough.. no idea where that extra NMI comes from.
> Robert any clue?
> 
...

For what is worth, I've tested amd turion box -- not affected.

	-- Cyrill
