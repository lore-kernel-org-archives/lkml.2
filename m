Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753543Ab0KSPoC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 10:44:02 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34820 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752035Ab0KSPn7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 10:43:59 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1290120166-3132-3-git-send-email-zohar@linux.vnet.ibm.com>
References: <1290120166-3132-3-git-send-email-zohar@linux.vnet.ibm.com> <1290120166-3132-1-git-send-email-zohar@linux.vnet.ibm.com>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, keyrings@linux-nfs.org,
        linux-crypto@vger.kernel.org,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        James Morris <jmorris@namei.org>,
        David Safford <safford@watson.ibm.com>,
        Rajiv Andrade <srajiv@linux.vnet.ibm.com>,
        Mimi Zohar <zohar@us.ibm.com>
Subject: Re: [PATCH v1.4 2/5] tpm: add module_put wrapper
Date: Fri, 19 Nov 2010 15:43:46 +0000
Message-ID: <9797.1290181426@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:

> For readability, define a tpm_chip_put() wrapper to call module_put().
> Replace existing module_put() calls with the wrapper.
> 
> (Change based on trusted/encrypted patchset review by David Howells.)
> 
> Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
> Signed-off-by: David Safford <safford@watson.ibm.com>

Acked-by: David Howells <dhowells@redhat.com>
