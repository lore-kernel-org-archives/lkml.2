Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753269Ab0FWRIt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 13:08:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6156 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753203Ab0FWRIr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 13:08:47 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1277220309-3757-1-git-send-email-sjayaraman@suse.de>
References: <1277220309-3757-1-git-send-email-sjayaraman@suse.de> <yes>
To: Suresh Jayaraman <sjayaraman@suse.de>
Cc: dhowells@redhat.com, Steve French <smfrench@gmail.com>,
       linux-cifs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 10/10] cifs: add mount option to enable local caching
Date: Wed, 23 Jun 2010 18:08:34 +0100
Message-ID: <9942.1277312914@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Suresh Jayaraman <sjayaraman@suse.de> wrote:

> Add a mount option 'fsc' to enable local caching on CIFS.
> 
> As the cifs-utils (userspace) changes are not done yet, this patch enables
> 'fsc' by default to assist testing.
> 
> Signed-off-by: Suresh Jayaraman <sjayaraman@suse.de>

Acked-by: David Howells <dhowells@redhat.com>

(Give or take the debugging bit)
