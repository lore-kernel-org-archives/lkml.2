Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755336Ab2IJRYg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 13:24:36 -0400
Received: from casper.infradead.org ([85.118.1.10]:46990 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751847Ab2IJRYf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 13:24:35 -0400
Message-ID: <1347297865.2124.49.camel@twins>
Subject: Re: [PATCH 2/3] perf: require exclude_guest to use PEBS - kernel
 side enforcement
From: Peter Zijlstra <peterz@infradead.org>
To: David Ahern <dsahern@gmail.com>
Cc: acme@ghostprotocols.net, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>,
        Robert Richter <robert.richter@amd.com>,
        Gleb Natapov <gleb@redhat.com>, Avi Kivity <avi@redhat.com>
Date: Mon, 10 Sep 2012 19:24:25 +0200
In-Reply-To: <1347295216-1202-3-git-send-email-dsahern@gmail.com>
References: <1347295216-1202-1-git-send-email-dsahern@gmail.com>
	 <1347295216-1202-3-git-send-email-dsahern@gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-09-10 at 10:40 -0600, David Ahern wrote:
> From: Peter Zijlstra <peterz@infradead.org>
> 
> See https://lkml.org/lkml/2012/7/9/298

Expanding that a little would be so much better.. take some of the reply
to 1/3 on why we have to enforce a strict exclude_guest.

