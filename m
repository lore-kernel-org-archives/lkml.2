Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751313Ab1AZLFt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 06:05:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36621 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750816Ab1AZLFs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 06:05:48 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1295887497-20198-2-git-send-email-roberto.sassu@polito.it>
References: <1295887497-20198-2-git-send-email-roberto.sassu@polito.it> <1295887497-20198-1-git-send-email-roberto.sassu@polito.it>
To: Roberto Sassu <roberto.sassu@polito.it>
Cc: dhowells@redhat.com, linux-security-module@vger.kernel.org,
        keyrings@linux-nfs.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, jmorris@namei.org,
        zohar@linux.vnet.ibm.com, safford@watson.ibm.com, ramunno@polito.it,
        tyhicks@linux.vnet.ibm.com, kirkland@canonical.com
Subject: Re: [RFC][PATCH v3 1/6] encrypted-keys: fixed valid_master_desc() function description
Date: Wed, 26 Jan 2011 11:05:32 +0000
Message-ID: <6047.1296039932@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roberto Sassu <roberto.sassu@polito.it> wrote:

> Valid key type prefixes for the parameter 'key-type' are: 'trusted' and
> 'user'.
> 
> Signed-off-by: Roberto Sassu <roberto.sassu@polito.it>
> Acked-by: Gianluca Ramunno <ramunno@polito.it>
> Acked-by: Mimi Zohar <zohar@us.ibm.com>

Acked-by: David Howells <dhowells@redhat.com>
