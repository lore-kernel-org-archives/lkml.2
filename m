Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753042Ab2AZQQo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 11:16:44 -0500
Received: from merlin.infradead.org ([205.233.59.134]:51190 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751483Ab2AZQQn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 11:16:43 -0500
Message-ID: <1327594589.2446.112.camel@twins>
Subject: Re: [PATCH] perf_events: fix broken intr throttling (v3)
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, gleb@redhat.com,
        wcohen@redhat.com, vince@deater.net, asharma@fb.com,
        andi@firstfloor.org
Date: Thu, 26 Jan 2012 17:16:29 +0100
In-Reply-To: <20120126160319.GA5655@quad>
References: <20120126160319.GA5655@quad>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-01-26 at 17:03 +0100, Stephane Eranian wrote:
> This patch fixes the throttling mechanism. It was broken
> in 3.2.0. Events were not being unthrottled. The unthrottling
> mechanism required that events be checked at each timer tick.
> 
> This patch solves this problem and also separates:
>   - unthrottling
>   - multiplexing
>   - frequency-mode period adjustments 

Thanks!
