Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756484Ab1BRPwK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 10:52:10 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:52331 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753393Ab1BRPwH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 10:52:07 -0500
Subject: Re: [PATCH 1/3] perf events: fix WARN_ON_ONCE for 64-bit raw data,
 SW events
From: Peter Zijlstra <peterz@infradead.org>
To: David Ahern <daahern@cisco.com>
Cc: linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        mingo@elte.hu, acme@ghostprotocols.net, paulus@samba.org
In-Reply-To: <4D5E9016.4070808@cisco.com>
References: <1298008433-22911-1-git-send-email-daahern@cisco.com>
	 <1298008433-22911-2-git-send-email-daahern@cisco.com>
	 <1298026821.5226.642.camel@laptop>  <4D5E8338.8010602@cisco.com>
	 <1298040938.5226.771.camel@laptop>  <4D5E9016.4070808@cisco.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 18 Feb 2011 16:51:56 +0100
Message-ID: <1298044316.2887.0.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-02-18 at 08:28 -0700, David Ahern wrote:

> Why is an 8-byte stride preferred over a 4-bytes?

So as to avoid having to deal with unaligned u64 reads.
