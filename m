Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752776Ab1AZLF2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 06:05:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38618 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751159Ab1AZLF0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 06:05:26 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1295887497-20198-5-git-send-email-roberto.sassu@polito.it>
References: <1295887497-20198-5-git-send-email-roberto.sassu@polito.it> <1295887497-20198-1-git-send-email-roberto.sassu@polito.it>
To: Roberto Sassu <roberto.sassu@polito.it>
Cc: dhowells@redhat.com, linux-security-module@vger.kernel.org,
        keyrings@linux-nfs.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, jmorris@namei.org,
        zohar@linux.vnet.ibm.com, safford@watson.ibm.com, ramunno@polito.it,
        tyhicks@linux.vnet.ibm.com, kirkland@canonical.com
Subject: Re: [RFC][PATCH v3 4/6] eCryptfs: export global eCryptfs definitions to include/linux/ecryptfs.h
Date: Wed, 26 Jan 2011 11:05:08 +0000
Message-ID: <6020.1296039908@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roberto Sassu <roberto.sassu@polito.it> wrote:

> Some eCryptfs specific definitions, such as the current version and the
> authentication token structure, are moved to the new include file
> 'include/linux/ecryptfs.h', in order to be available for all kernel
> subsystems.
> 
> Signed-off-by: Roberto Sassu <roberto.sassu@polito.it>
> Acked-by: Gianluca Ramunno <ramunno@polito.it>
> Acked-by: Tyler Hicks <tyhicks@linux.vnet.ibm.com>

Acked-by: David Howells <dhowells@redhat.com>
