Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933498Ab0JZSNx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 14:13:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7396 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933445Ab0JZSNw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 14:13:52 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1288045918-25233-1-git-send-email-andi@firstfloor.org>
References: <1288045918-25233-1-git-send-email-andi@firstfloor.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org, keyrings@linux-nfs.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH] Fix install_process_keyring error handling
Date: Tue, 26 Oct 2010 19:13:39 +0100
Message-ID: <17157.1288116819@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen <andi@firstfloor.org> wrote:

> From: Andi Kleen <ak@linux.intel.com>
> 
> Fix incorrect error check that returns 1 for error
> instead of the expected error code.
> 
> Signed-off-by: Andi Kleen <ak@linux.intel.com>

Good catch.

David
