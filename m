Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759263Ab2EWKOM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 06:14:12 -0400
Received: from merlin.infradead.org ([205.233.59.134]:53662 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751409Ab2EWKOK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 06:14:10 -0400
Message-ID: <1337768040.9698.66.camel@twins>
Subject: Re: [PATCH 1/2] sched: add virt sched domain for the guest
From: Peter Zijlstra <peterz@infradead.org>
To: Liu ping fan <kernelfans@gmail.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, qemu-devel@nongnu.org,
        Ingo Molnar <mingo@redhat.com>, Avi Kivity <avi@redhat.com>,
        Anthony Liguori <anthony@codemonkey.ws>
Date: Wed, 23 May 2012 12:14:00 +0200
In-Reply-To: <CAFgQCTuzuscs8piDms3t8HyBTsFSfNiVf1JcDQ=UX8PQpUiU3w@mail.gmail.com>
References: <1337754751-9018-1-git-send-email-kernelfans@gmail.com>
	 <1337754751-9018-2-git-send-email-kernelfans@gmail.com>
	 <1337759644.9698.49.camel@twins>
	 <CAFgQCTvhVs8-onz3huovYe=StOYJe2pJO-nka_7KogSju6AttQ@mail.gmail.com>
	 <1337761402.9698.62.camel@twins>
	 <CAFgQCTt+cmUWUB6GvE=Ki5ikC1P7YA_sGrvgUKKJ6c3VuqCsAg@mail.gmail.com>
	 <1337762914.9698.65.camel@twins>
	 <CAFgQCTuzuscs8piDms3t8HyBTsFSfNiVf1JcDQ=UX8PQpUiU3w@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-23 at 17:58 +0800, Liu ping fan wrote:
> > Please go do something else, I'll do this.
> 
OK so that was to say never, as in dynamic cpu:node relations aren't
going to happen. but tip/sched/numa contain the bits needed to make
vnuma work.
