Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753788Ab2DCAsb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 20:48:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43995 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751333Ab2DCAs3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 20:48:29 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20120402130705.285e5dc0@corrin.poochiereds.net>
References: <20120402130705.285e5dc0@corrin.poochiereds.net> <20120328104607.10417.85745.stgit@warthog.procyon.org.uk> <20120328104619.10417.78851.stgit@warthog.procyon.org.uk> <1332934098.2297.11.camel@falcor>
To: Jeff Layton <jlayton@redhat.com>
Cc: dhowells@redhat.com, Mimi Zohar <zohar@linux.vnet.ibm.com>,
        jmorris@namei.org, linux-security-module@vger.kernel.org,
        keyrings@linux-nfs.org, linux-kernel@vger.kernel.org
Subject: Re: [Keyrings] [PATCH 2/9] keys: update the description with info about "logon" keys
Date: Tue, 03 Apr 2012 01:48:20 +0100
Message-ID: <15116.1333414100@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Layton <jlayton@redhat.com> wrote:

> Sorry for the late response. I somehow missed this email a few days
> ago. I can reword it to make it a bit clearer. David, should I send a
> respin of this patch or a new one on top of this one?

If it's just a doc fix, reword the patch and post it again.  It can be sent
straight to Linus with a note that it doesn't actually affect any code.

David
