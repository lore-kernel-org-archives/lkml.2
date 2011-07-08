Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753427Ab1GHAcc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 20:32:32 -0400
Received: from smtp-out.google.com ([74.125.121.67]:41437 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752986Ab1GHAca (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 20:32:30 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:x-x-sender:to:cc:subject:
	in-reply-to:message-id:references:user-agent:mime-version:content-type:x-system-of-record;
	b=e0K6kp4pYkX76wiJij9lodFoYIREWs/tXX5Upam340OBBG14w3TVS1hkutlF+I8Pi
	cLtqsMD5NNxJUU3TRhMvg==
Date: Thu, 7 Jul 2011 17:32:10 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@sister.anvils
To: Wengang Wang <wen.gang.wang@oracle.com>
cc: stable@kernel.org, greg.marsden@oracle.com, joe.jin@oracle.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: prevent concurrent unmap_mapping_range() on the same
 inode --to stable
In-Reply-To: <20110704020003.GA4262@laptop.us.oracle.com>
Message-ID: <alpine.LSU.2.00.1107071715020.10234@sister.anvils>
References: <20110704020003.GA4262@laptop.us.oracle.com>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 Jul 2011, Wengang Wang wrote:
> 
> Any comment on the backport?

You don't mention which release it's a backport to.
2.6.38 and 2.6.39 base releases and 2.6.37.6 already include the fix.

It could be valuable to backport to the -longterm releases,
but a simple rediff would not be enough: things moved around.

Hugh
