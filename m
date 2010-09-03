Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755157Ab0ICHkc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 03:40:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37064 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753265Ab0ICHkb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 03:40:31 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1283442391-23612-4-git-send-email-namhyung@gmail.com>
References: <1283442391-23612-4-git-send-email-namhyung@gmail.com> <1283442391-23612-1-git-send-email-namhyung@gmail.com>
To: Namhyung Kim <namhyung@gmail.com>
Cc: dhowells@redhat.com, Roland McGrath <roland@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH v2 03/24] ptrace: change signature of arch_ptrace()
Date: Fri, 03 Sep 2010 08:40:24 +0100
Message-ID: <7945.1283499624@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Namhyung Kim <namhyung@gmail.com> wrote:

> Fix up the arguments to arch_ptrace() to take account of the fact that
> @addr and @data are now unsigned long rather than long as of a preceding
> patch in this series.

Acked-by: David Howells <dhowells@redhat.com>
