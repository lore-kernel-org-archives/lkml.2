Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754309Ab2GWSJp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 14:09:45 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:56291 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751491Ab2GWSJo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 14:09:44 -0400
Date: Mon, 23 Jul 2012 20:09:36 +0200
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: David Ahern <dsahern@gmail.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 05/11] perf kvm: use strtol for walking guestmount
 directory
Message-ID: <20120723180936.GA6717@infradead.org>
References: <1342826756-64663-1-git-send-email-dsahern@gmail.com>
 <1342826756-64663-6-git-send-email-dsahern@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1342826756-64663-6-git-send-email-dsahern@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Jul 20, 2012 at 05:25:50PM -0600, David Ahern escreveu:
> Signed-off-by: David Ahern <dsahern@gmail.com>

Why is this patch needed? Rethorical question, please resubmit with an
answer in the changeset comment :-)

- Arnaldo
