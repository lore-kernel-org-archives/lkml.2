Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755901Ab2D3JEz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 05:04:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12577 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752041Ab2D3JEx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 05:04:53 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20120422212220.GA6537@merkur.ravnborg.org>
References: <20120422212220.GA6537@merkur.ravnborg.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: dhowells@redhat.com, linux arch <linux-arch@vger.kernel.org>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, Michal Marek <mmarek@suse.cz>
Subject: Re: [RFC] move link of vmlinux to a script
Date: Mon, 30 Apr 2012 10:04:19 +0100
Message-ID: <21193.1335776659@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg <sam@ravnborg.org> wrote:

> +#   C = Comon symbol

Should be "Common" I presume.  Could you fix it whilst you're at it?

David
