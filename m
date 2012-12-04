Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752518Ab2LDSQO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 13:16:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50725 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751090Ab2LDSQN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 13:16:13 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1354616321-13520-1-git-send-email-mmarek@suse.cz>
References: <1354616321-13520-1-git-send-email-mmarek@suse.cz>
To: Michal Marek <mmarek@suse.cz>
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org, rusty@ozlabs.org
Subject: Re: [PATCH 1/3] MODSIGN: Fix comparison erros in scripts/sign-file
Date: Tue, 04 Dec 2012 18:15:22 +0000
Message-ID: <22365.1354644922@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michal Marek <mmarek@suse.cz> wrote:

> Signed-off-by: Michal Marek <mmarek@suse.cz>

If only perl gave you warnings for this as gcc does...

Acked-by: David Howells <dhowells@redhat.com>
