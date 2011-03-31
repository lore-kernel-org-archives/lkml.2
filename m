Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757370Ab1CaLlv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 07:41:51 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:36673 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752232Ab1CaLlu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 07:41:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=B7Nx/gQ8zi2XDBHwhT+jdgFGmNLWXrhgDjKd5/QPTAjbctnkr1tP8hOoyW20uWvinA
         OeHmrnP7lVXcKnFk/+0CUO09n980Jc9xsFLku7QnTVKKGdDwPm/cO4v18aWPx73nQ14x
         rofjfM8dheRw3zBU74Xj2MPDdcKbv+ztt+BEA=
Date: Thu, 31 Mar 2011 13:41:45 +0200
From: Tejun Heo <tj@kernel.org>
To: Florian Mickler <florian@mickler.org>
Cc: linux-kernel@vger.kernel.org, rdunlap@xenotime.net,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH] workqueue: document debugging tricks
Message-ID: <20110331114145.GC3385@htj.dyndns.org>
References: <20110331065642.GA3385@htj.dyndns.org>
 <1301567826-6116-1-git-send-email-florian@mickler.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1301567826-6116-1-git-send-email-florian@mickler.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 31, 2011 at 12:37:06PM +0200, Florian Mickler wrote:
> It is not obvious how to debug run-away workers.
> 
> These are some tips given by Tejun on lkml.
> 
> Signed-off-by: Florian Mickler <florian@mickler.org>
> CC: Tejun Heo <tj@kernel.org>

Right, good idea.  Applied to fixes-2.6.39 with minor formatting
changes.

Thanks.

-- 
tejun
