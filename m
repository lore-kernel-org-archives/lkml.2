Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759311Ab1JFVlk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 17:41:40 -0400
Received: from smtp-out.google.com ([74.125.121.67]:24304 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757353Ab1JFVlj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 17:41:39 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:date:
	message-id:subject:from:to:cc:content-type:x-system-of-record;
	b=LnyTgbETGq1LeUr91kLpLYCSlYmzptJ6ykYuihnXwq5kP1hph/qaU3Ikp/iQ/kQl2
	fSeaQMfg6sj8KsW2AjjHw==
MIME-Version: 1.0
In-Reply-To: <1317925923.9813.4.camel@twins>
References: <1317912555-9559-1-git-send-email-eranian@google.com>
	<1317925923.9813.4.camel@twins>
Date: Thu, 6 Oct 2011 23:41:35 +0200
Message-ID: <CABPqkBRuoP2f8BbF1cd_LAAm9fK=BYNotOo+n0K0bvLafNqO3g@mail.gmail.com>
Subject: Re: [PATCH 00/12] perf_events: add support for sampling taken branches
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, acme@redhat.com,
        ming.m.lin@intel.com, andi@firstfloor.org, robert.richter@amd.com,
        ravitillo@lbl.gov
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 6, 2011 at 8:32 PM, Peter Zijlstra <peterz@infradead.org> wrote:
>
> This doesn't apply at all, its against some ancient tree. Please re-spin
> against a current tip/master or so.
>
It is against Linus' 3.1-rc9 commit 976d167.
I will re-spin tomorrow and cc the arch maintainers too.
