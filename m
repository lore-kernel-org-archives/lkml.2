Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755813Ab0G0JAg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 05:00:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58201 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753629Ab0G0JAf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 05:00:35 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20100726204312.GB18853@merkur.ravnborg.org>
References: <20100726204312.GB18853@merkur.ravnborg.org> <20100726203814.GA18828@merkur.ravnborg.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: dhowells@redhat.com, Michal Marek <mmarek@suse.cz>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] frv: remove useless ARCHMODFLAGS assignment
Date: Tue, 27 Jul 2010 10:00:25 +0100
Message-ID: <13144.1280221225@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg <sam@ravnborg.org> wrote:

> There is no references to ARCHMODLFAGS throughout the kernel tree.

Ummm...  Okay.  I guess modules don't work on FRV then.

> Signed-off-by: Sam Ravnborg <sam@ravnborg.org>

Acked-by: David Howells <dhowells@redhat.com>
