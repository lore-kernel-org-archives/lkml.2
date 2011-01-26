Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752925Ab1AZKtw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 05:49:52 -0500
Received: from mx1.redhat.com ([209.132.183.28]:28839 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752581Ab1AZKtu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 05:49:50 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1295887497-20198-3-git-send-email-roberto.sassu@polito.it>
References: <1295887497-20198-3-git-send-email-roberto.sassu@polito.it> <1295887497-20198-1-git-send-email-roberto.sassu@polito.it>
To: Roberto Sassu <roberto.sassu@polito.it>
Cc: dhowells@redhat.com, linux-security-module@vger.kernel.org,
        keyrings@linux-nfs.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, jmorris@namei.org,
        zohar@linux.vnet.ibm.com, safford@watson.ibm.com, ramunno@polito.it,
        tyhicks@linux.vnet.ibm.com, kirkland@canonical.com
Subject: Re: [RFC][PATCH v3 2/6] encrypted-keys: added additional debug messages
Date: Wed, 26 Jan 2011 10:49:29 +0000
Message-ID: <5456.1296038969@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roberto Sassu <roberto.sassu@polito.it> wrote:

> +		pr_err("encrypted_key: insufficient parameters specified\n");

I think pr_err() is probably too high a message level.  This is a user error
not a kernel error.  I would recommend something like pr_info() or possibly
pr_debug().

David
