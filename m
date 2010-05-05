Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758875Ab0EEKDt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 06:03:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27997 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751342Ab0EEKDs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 06:03:48 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20100505032033.GA19232@google.com>
References: <20100505032033.GA19232@google.com>
To: Michel Lespinasse <walken@google.com>
Cc: dhowells@redhat.com, Andrew Morton <akpm@google.com>,
       Linux-MM <linux-mm@kvack.org>, Ying Han <yinghan@google.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: rwsem: down_read_unfair() proposal
Date: Wed, 05 May 2010 11:03:40 +0100
Message-ID: <22933.1273053820@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


If the system is as heavily loaded as you say, how do you prevent writer
starvation?  Or do things just grind along until sufficient threads are queued
waiting for a write lock?

David
