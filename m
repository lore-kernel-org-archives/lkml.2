Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754963Ab1ASVut (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 16:50:49 -0500
Received: from tundra.namei.org ([65.99.196.166]:50961 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754692Ab1ASVud (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 16:50:33 -0500
Date: Thu, 20 Jan 2011 08:50:27 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: David Howells <dhowells@redhat.com>
cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, keyrings@linux-nfs.org,
        David Safford <safford@watson.ibm.com>, Mimi Zohar <zohar@us.ibm.com>
Subject: Re: [PATCH 1/3] trusted-keys: rename trusted_defined files to
 trusted
In-Reply-To: <21651.1295362722@redhat.com>
Message-ID: <alpine.LRH.2.00.1101200850050.5107@tundra.namei.org>
References: <1295359633-4993-1-git-send-email-zohar@linux.vnet.ibm.com> <21651.1295362722@redhat.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Jan 2011, David Howells wrote:

> Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
> 
> > Rename trusted_defined.c and trusted_defined.h files to trusted.c and
> > trust.h, respectively. Based on request from David Howells.
> 
> Or even to trusted.h.
> 
> Apart from that, feel free to add my Acked-by.

It is trusted.h in the changeset, the comment is wrong.

-- 
James Morris
<jmorris@namei.org>
