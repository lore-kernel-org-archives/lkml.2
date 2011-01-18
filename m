Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752548Ab1ARPAJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 10:00:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:5661 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752518Ab1ARPAH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 10:00:07 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1295359633-4993-2-git-send-email-zohar@linux.vnet.ibm.com>
References: <1295359633-4993-2-git-send-email-zohar@linux.vnet.ibm.com> <1295359633-4993-1-git-send-email-zohar@linux.vnet.ibm.com>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, keyrings@linux-nfs.org,
        James Morris <jmorris@namei.org>,
        David Safford <safford@watson.ibm.com>, Mimi Zohar <zohar@us.ibm.com>
Subject: Re: [PATCH 2/3] encrypted-keys: rename encrypted_defined files to encrypted
Date: Tue, 18 Jan 2011 15:00:01 +0000
Message-ID: <21692.1295362801@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:

> Rename encrypted_defined.c and encrypted_defined.h files to encrypted.c and
> encrypted.h, respectively. Based on request from David Howells.
> 
> Signed-off-by: Mimi Zohar <zohar@us.ibm.com>

Acked-by: David Howells <dhowells@redhat.com>
