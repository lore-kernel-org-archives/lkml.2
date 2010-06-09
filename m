Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932446Ab0FIS47 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 14:56:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42380 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932308Ab0FIS45 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 14:56:57 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <E1OMQ88-0002a1-Gb@closure.thunk.org>
References: <E1OMQ88-0002a1-Gb@closure.thunk.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: dhowells@redhat.com, Dave Airlie <airlied@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Why is kslowd accumulating so much CPU time?
Date: Wed, 09 Jun 2010 19:56:52 +0100
Message-ID: <21934.1276109812@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Theodore Ts'o <tytso@mit.edu> wrote:

> Is there any way to easily see what is scheduling themselves to use the
> slow workqueue?

Slow work has debugging.  Turn on:

	CONFIG_SLOW_WORK_DEBUG=y

then do:

	watch -n0 cat /sys/kernel/debug/slow_work/runqueue

David
