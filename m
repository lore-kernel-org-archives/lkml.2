Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932439Ab2BNVEt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 16:04:49 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:41214 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932388Ab2BNVEs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 16:04:48 -0500
Date: Tue, 14 Feb 2012 13:04:45 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Dan Smith <danms@us.ibm.com>
cc: akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Ensure that walk_page_range()'s start and end are
 page-aligned
In-Reply-To: <87pqdh1mvs.fsf@caffeine.danplanet.com>
Message-ID: <alpine.DEB.2.00.1202141259420.28450@chino.kir.corp.google.com>
References: <1328902796-30389-1-git-send-email-danms@us.ibm.com> <alpine.DEB.2.00.1202130211400.4324@chino.kir.corp.google.com> <87zkcm23az.fsf@caffeine.danplanet.com> <alpine.DEB.2.00.1202131350500.17296@chino.kir.corp.google.com>
 <87pqdh1mvs.fsf@caffeine.danplanet.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Feb 2012, Dan Smith wrote:

> I'd rather just make it always do the check in walk_page_range(). Does
> that sound reasonable?
> 

And do what if they're not?  What behavior are you trying to fix from the 
pagewalk code with respect to page-aligned addresses?  Any specific 
examples?
