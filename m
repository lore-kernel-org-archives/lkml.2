Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755089Ab2FYJp7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 05:45:59 -0400
Received: from casper.infradead.org ([85.118.1.10]:41407 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751482Ab2FYJp6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 05:45:58 -0400
Subject: Re: [BUG] sched: clock wrap bug in 2.6.35-stable kills scheduling
From: Peter Zijlstra <peterz@infradead.org>
To: Thomas Lange <thomas@corelatus.se>
Cc: mingo@redhat.com, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
In-Reply-To: <4FE74F1B.6070803@corelatus.se>
References: <4FE74F1B.6070803@corelatus.se>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 25 Jun 2012 11:45:41 +0200
Message-ID: <1340617541.2507.50.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-06-24 at 19:32 +0200, Thomas Lange wrote:
> Bug was introduced in 2.6.35.12 and is still present in linux-2.6.35.y HEAD.

Ok, so nobody cares about that.. what does something recent like 3.5-rc4
do?

If that's fixed, find the patch that fixes it. If not, we'll have a
look.

