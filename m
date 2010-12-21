Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752153Ab0LURs5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 12:48:57 -0500
Received: from mail-bw0-f45.google.com ([209.85.214.45]:53604 "EHLO
	mail-bw0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751478Ab0LURs4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 12:48:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ambcKO6L5ei4Y4PsuLfbWd4WER/cXWnWBOaY7+q5cEHps+7p9BFVojs3BOn/q819HG
         qc0KaxOLLfxA2yjulQv5QcIkCMwDHtcJkHmL52JWMQGvv5tFklw0+F//BAdlQsRiO5NR
         g31IKxeVkB4m3y49MUlXZGmEiY55Reg22XMvk=
Date: Tue, 21 Dec 2010 18:48:50 +0100
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: roland@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org, rjw@sisk.pl,
        jan.kratochvil@redhat.com
Subject: Re: [PATCH 14/16] ptrace: make SIGCONT notification reliable
 against ptrace
Message-ID: <20101221174849.GI13285@htj.dyndns.org>
References: <1291654624-6230-1-git-send-email-tj@kernel.org>
 <1291654624-6230-15-git-send-email-tj@kernel.org>
 <20101220194354.GA23281@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101220194354.GA23281@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Oleg.

On Mon, Dec 20, 2010 at 08:43:54PM +0100, Oleg Nesterov wrote:
> I must admit, I have some concerns.

Hey, join the club.

> But most probably I just need to actually understand what this patch
> does.

The bigger question is about the direction tho.  The patchset
definitely still has enough holes but do you in general agree with
where it's headed?  If so, maybe it would be a good idea to set up an
incremental devel branch somewhere?  We definitely need more review
rounds but given the fragility of the whole thing I think it would be
wiser to keep the spotted problems and fixes in changelog after the
general direction is agreed on.

Thanks.

-- 
tejun
