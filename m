Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758212Ab0FITAx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 15:00:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1082 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751470Ab0FITAw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 15:00:52 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <21934.1276109812@redhat.com>
References: <21934.1276109812@redhat.com> <E1OMQ88-0002a1-Gb@closure.thunk.org>
Cc: dhowells@redhat.com, "Theodore Ts'o" <tytso@mit.edu>,
       Dave Airlie <airlied@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: Why is kslowd accumulating so much CPU time?
Date: Wed, 09 Jun 2010 20:00:45 +0100
Message-ID: <22070.1276110045@redhat.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Howells <dhowells@redhat.com> wrote:

> > Is there any way to easily see what is scheduling themselves to use the
> > slow workqueue?
> 
> Slow work has debugging.  Turn on:
> 
> 	CONFIG_SLOW_WORK_DEBUG=y
> 
> then do:
> 
> 	watch -n0 cat /sys/kernel/debug/slow_work/runqueue

I documented this, of course.  Look in:

	Documentation/slow-work.txt

in section "VIEWING EXECUTING AND QUEUED ITEMS".

David
