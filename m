Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932776Ab1KGQqY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 11:46:24 -0500
Received: from casper.infradead.org ([85.118.1.10]:56826 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755804Ab1KGQqX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 11:46:23 -0500
Subject: Re: [PATCHv2 2/9] KVM: Expose a version 2 architectural PMU to a
 guests
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Gleb Natapov <gleb@redhat.com>
Cc: kvm@vger.kernel.org, avi@redhat.com, mtosatti@redhat.com,
        linux-kernel@vger.kernel.org, mingo@elte.hu, acme@ghostprotocols.net
Date: Mon, 07 Nov 2011 17:45:14 +0100
In-Reply-To: <20111107152540.GF8670@redhat.com>
References: <1320323618-10375-1-git-send-email-gleb@redhat.com>
	 <1320323618-10375-3-git-send-email-gleb@redhat.com>
	 <1320676609.18053.44.camel@twins> <20111107152540.GF8670@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1320684314.17809.29.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-11-07 at 17:25 +0200, Gleb Natapov wrote:
> > Since the below programming doesn't use perf_event_attr::pinned, yes.
> > 
> Yes, that is on todo :). Actually I do want to place all guest perf
> counters into the same event group and make it pinned. But currently perf
> event groups are not very flexible. In our usage scenario we can't have
> one event as a group leader since events are created and destroyed very
> dynamically. What I would like is to have something like meta event that
> will group all other real event. 

Is there a reason to have them grouped if you pin them all anyway?
