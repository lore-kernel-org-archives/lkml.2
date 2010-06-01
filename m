Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755683Ab0FAJwA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 05:52:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27057 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752775Ab0FAJv7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 05:51:59 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1274863421-14052-1-git-send-email-vapier@gentoo.org>
References: <1274863421-14052-1-git-send-email-vapier@gentoo.org>
To: Mike Frysinger <vapier@gentoo.org>
Cc: dhowells@redhat.com, uclinux-dev@uclinux.org,
       David McCullough <davidm@snapgear.com>, Greg Ungerer <gerg@uclinux.org>,
       Paul Mundt <lethal@linux-sh.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] FLAT: fix unmap len in load error path
Date: Tue, 01 Jun 2010 10:50:55 +0100
Message-ID: <27142.1275385855@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Frysinger <vapier@gentoo.org> wrote:

> The data chunk is mmaped with 'len' which remains unchanged, so use that
> when unmapping in the error path rather than trying to recalculate (and
> incorrectly so) the value used originally.
> 
> Signed-off-by: Mike Frysinger <vapier@gentoo.org>

Acked-by: David Howells <dhowells@redhat.com>
