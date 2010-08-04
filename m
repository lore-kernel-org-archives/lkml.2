Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932191Ab0HDKXZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 06:23:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25560 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751351Ab0HDKXX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 06:23:23 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20100802112014.481889344@szeredi.hu>
References: <20100802112014.481889344@szeredi.hu> <20100802111955.025275647@szeredi.hu>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: dhowells@redhat.com, viro@ZenIV.linux.org.uk,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/7] cachefiles: use path_get instead of lone dget
Date: Wed, 04 Aug 2010 11:23:08 +0100
Message-ID: <24288.1280917388@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Miklos Szeredi <miklos@szeredi.hu> wrote:

> From: Miklos Szeredi <mszeredi@suse.cz>
> 
> Dentry references should not be acquired without a corresponding
> vfsmount ref.
> 
> CC: David Howells <dhowells@redhat.com>
> Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>

Acked-by: David Howells <dhowells@redhat.com>
