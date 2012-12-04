Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752911Ab2LDSSQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 13:18:16 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52969 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751722Ab2LDSSO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 13:18:14 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1354616321-13520-2-git-send-email-mmarek@suse.cz>
References: <1354616321-13520-2-git-send-email-mmarek@suse.cz> <1354616321-13520-1-git-send-email-mmarek@suse.cz>
To: Michal Marek <mmarek@suse.cz>
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org, rusty@ozlabs.org,
        Takashi Iwai <tiwai@suse.de>
Subject: Re: [PATCH 2/3] MODSIGN: Avoid using .incbin in C source
Date: Tue, 04 Dec 2012 18:17:28 +0000
Message-ID: <22396.1354645048@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michal Marek <mmarek@suse.cz> wrote:

> Using the asm .incbin statement in C sources breaks any gcc wrapper which
> assumes that preprocessed C source is self-contained. Use a separate .S
> file to include the siging key and certificate.

I was trying to avoid that as .S files generally don't crop up in generic
code and the format of the assembly varies with the arch.  However, you don't
seem to have anything that should cause a problem - so:

Acked-by: David Howells <dhowells@redhat.com>
