Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752099Ab1IUCvg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 22:51:36 -0400
Received: from smtp-out.google.com ([216.239.44.51]:6171 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751678Ab1IUCve (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 22:51:34 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:date:
	message-id:subject:from:to:cc:content-type:x-system-of-record;
	b=rMf1rbtAQztnNClBnpWrqVgFkQ9qUWo41I67ACPiw97w46pu1zwDEYYmsqfx3kMHP
	Tkb0OFeedB3kLNLYEerTg==
MIME-Version: 1.0
In-Reply-To: <4E78E3DF.1070501@redhat.com>
References: <1316230753-8693-1-git-send-email-walken@google.com>
	<1316230753-8693-2-git-send-email-walken@google.com>
	<4E78E3DF.1070501@redhat.com>
Date: Tue, 20 Sep 2011 19:51:29 -0700
Message-ID: <CANN689EkOMyUuMCZFBHMUtq85uU-233c-4i3_cT=ZqfYVW1JjQ@mail.gmail.com>
Subject: Re: [PATCH 1/8] page_referenced: replace vm_flags parameter with
 struct pr_info
From: Michel Lespinasse <walken@google.com>
To: Rik van Riel <riel@redhat.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <jweiner@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Michael Wolf <mjwolf@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 20, 2011 at 12:05 PM, Rik van Riel <riel@redhat.com> wrote:
> I have to agree with Joe's suggested name change.
>
> Other than that, this patch looks good (will ack the next version).

Very sweet ! I'll make sure to send that out soon. I think it's
easiest if I wait for you to review the current patches first, though
? (I'll send an incremental diff along with the next patch series)

Thanks a lot for having a look.

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
