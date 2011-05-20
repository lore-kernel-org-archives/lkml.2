Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933139Ab1ETPFl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 11:05:41 -0400
Received: from casper.infradead.org ([85.118.1.10]:35060 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932449Ab1ETPFk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 11:05:40 -0400
Subject: Re: [PATCH 2/3] perf_events: fix validation of events using an
 extra reg (v2)
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, andi@firstfloor.org,
        ming.m.lin@intel.com
In-Reply-To: <20110520143716.GA5381@quad>
References: <20110520143716.GA5381@quad>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 20 May 2011 17:05:17 +0200
Message-ID: <1305903917.2466.7237.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-05-20 at 16:37 +0200, Stephane Eranian wrote:
> The is_fake field is necessary to avoid a lockdep issue having
> to do with interrupt masking and era->lock.

Why not simply disable IRQs in both validate_* functions?
