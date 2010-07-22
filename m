Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759574Ab0GVRe7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 13:34:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27526 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759343Ab0GVRe4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 13:34:56 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20100722173251.1512.29858.stgit@warthog.procyon.org.uk>
References: <20100722173251.1512.29858.stgit@warthog.procyon.org.uk>
Cc: dhowells@redhat.com, smfrench@gmail.com, jlayton@redhat.com,
        linux-fsdevel@vger.kernel.org, linux-cifs@vger.kernel.org,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] KEYS: Authorise keyctl_set_timeout() on a key if we have its authorisation key
Date: Thu, 22 Jul 2010 18:34:47 +0100
Message-ID: <1726.1279820087@redhat.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Btw, these are based on the linux-cifs GIT tree.

David
