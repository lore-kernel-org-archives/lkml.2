Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756206Ab2IJQ5b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 12:57:31 -0400
Received: from casper.infradead.org ([85.118.1.10]:46482 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751438Ab2IJQ5a convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 12:57:30 -0400
Message-ID: <1347296241.2124.32.camel@twins>
Subject: Re: [PATCH 0/3] perf: precise mode and exclude_guest
From: Peter Zijlstra <peterz@infradead.org>
To: David Ahern <dsahern@gmail.com>
Cc: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Date: Mon, 10 Sep 2012 18:57:21 +0200
In-Reply-To: <1347295216-1202-1-git-send-email-dsahern@gmail.com>
References: <1347295216-1202-1-git-send-email-dsahern@gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-09-10 at 10:40 -0600, David Ahern wrote:
> Hopefully thi wraps up the precise mode-exclude_guest dependency.
> I'm sure someone will let me know if I screwed up the attribution
> in the second patch.


I'll wait with applying until we have the IBS stuff sorted, other than
that, thanks for collecting this..
