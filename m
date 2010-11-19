Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754164Ab0KSQp7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 11:45:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59698 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752531Ab0KSQp5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 11:45:57 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1290182696.2597.18.camel@localhost.localdomain>
References: <1290182696.2597.18.camel@localhost.localdomain> <1290120166-3132-4-git-send-email-zohar@linux.vnet.ibm.com> <1290120166-3132-1-git-send-email-zohar@linux.vnet.ibm.com> <9837.1290181537@redhat.com>
To: David Safford <safford@watson.ibm.com>
Cc: dhowells@redhat.com, Mimi Zohar <zohar@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        keyrings@linux-nfs.org, linux-crypto@vger.kernel.org,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        James Morris <jmorris@namei.org>,
        Rajiv Andrade <srajiv@linux.vnet.ibm.com>,
        Mimi Zohar <zohar@watson.ibm.com>
Subject: Re: [PATCH v1.4 3/5] key: add tpm_send command
Date: Fri, 19 Nov 2010 16:45:44 +0000
Message-ID: <10612.1290185144@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Safford <safford@watson.ibm.com> wrote:

> Currently transmit_command() in tpm.c expects an int,
> but it changes it to size_t for the actual tpm_transmit().
> We will work with Rajiv to do a cleanup, as this touches
> a number of calls.

You can pass a size_t value to an int.  The compiler will cast automatically.

David
