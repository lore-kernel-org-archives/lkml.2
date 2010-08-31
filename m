Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757311Ab0HaMqB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 08:46:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58933 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756930Ab0HaMqA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 08:46:00 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1282950518-7094-2-git-send-email-vapier@gentoo.org>
References: <1282950518-7094-2-git-send-email-vapier@gentoo.org> <1282950518-7094-1-git-send-email-vapier@gentoo.org>
To: Mike Frysinger <vapier@gentoo.org>
Cc: dhowells@redhat.com, uclinux-dist-devel@blackfin.uclinux.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] Blackfin: punt duplicate SPORT MMR defines
Date: Tue, 31 Aug 2010 13:45:40 +0100
Message-ID: <7447.1283258740@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Frysinger <vapier@gentoo.org> wrote:

> The common bfin_sport.h header now has unified definitions of these, so
> stop polluting the global namespace.
> 
> Signed-off-by: Mike Frysinger <vapier@gentoo.org>

Acked-by: David Howells <dhowells@redhat.com>
