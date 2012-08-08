Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030535Ab2HHR7P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 13:59:15 -0400
Received: from plane.gmane.org ([80.91.229.3]:44787 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759016Ab2HHR7N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 13:59:13 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Lutz Vieweg <lvml@5t9.de>
Subject: Re: What happened to TRIM support for raid linear/0/1/10?
Date: Wed, 08 Aug 2012 19:58:56 +0200
Message-ID: <jvu9cv$epn$1@dough.gmane.org>
References: <alpine.LRH.2.02.1208081308380.30954@praktifix.dwd.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: barriere.frankfurter-softwarefabrik.de
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120601 Thunderbird/13.0
In-Reply-To: <alpine.LRH.2.02.1208081308380.30954@praktifix.dwd.de>
Cc: linux-raid@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/08/2012 03:10 PM, Holger Kiehl wrote:
> Personally, I would think that TRIM support MD would be a very good thing.

That's one thing I am waiting for, too.

We had to implement a somewhat clumsy user-space application which does
the trick for us - but that is an ugly work-around, as it has to allocate
most of the free space on a filesystem for at least a little while (to know
what blocks it can discard).

Without periodic discard runs, our SSD-equipped servers suffer a ~50% write
performance penalty, so this feature is not just a cosmetic issue to us.

Regards,

Lutz Vieweg

