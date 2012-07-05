Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753815Ab2GEQGh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 12:06:37 -0400
Received: from merlin.infradead.org ([205.233.59.134]:46936 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751355Ab2GEQGg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 12:06:36 -0400
Message-ID: <1341504351.7709.6.camel@twins>
Subject: Re: [PATCH 2/3] perf, tool: Enable grouping logic for parsed events
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>, acme@redhat.com, mingo@elte.hu,
        paulus@samba.org, cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, andi@firstfloor.org,
        drepper@gmail.com
Date: Thu, 05 Jul 2012 18:05:51 +0200
In-Reply-To: <20120704173407.GA2880@krava.redhat.com>
References: <1340960907-3725-1-git-send-email-jolsa@redhat.com>
	 <1340960907-3725-3-git-send-email-jolsa@redhat.com>
	 <87bojync4b.fsf@sejong.aot.lge.com> <20120702101010.GB967@krava.redhat.com>
	 <873959mzi3.fsf@sejong.aot.lge.com>
	 <20120704173407.GA2880@krava.redhat.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-07-04 at 19:34 +0200, Jiri Olsa wrote:
> or any other way.. ;) thoughts?

What again was the downside if always doing additive (instead of
overriding) attributes?
