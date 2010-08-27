Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753069Ab0H0LB5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 07:01:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19580 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751532Ab0H0LBz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 07:01:55 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1282902149-12991-15-git-send-email-namhyung@gmail.com>
References: <1282902149-12991-15-git-send-email-namhyung@gmail.com> <1282902149-12991-1-git-send-email-namhyung@gmail.com>
To: Namhyung Kim <namhyung@gmail.com>
Cc: dhowells@redhat.com, Roland McGrath <roland@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 14/43] ptrace, frv: change signature of arch_ptrace()
Date: Fri, 27 Aug 2010 12:01:46 +0100
Message-ID: <4072.1282906906@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Namhyung Kim <namhyung@gmail.com> wrote:

> change type of @addr and @data into unsigned long according to commit
> f76671df26ef06321480e702770f88f61272be29 [PATCH 03/43]

That description means nothing.  Commit
f76671df26ef06321480e702770f88f61272be29 is not upstream.

David
