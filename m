Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752795Ab1AWXdA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jan 2011 18:33:00 -0500
Received: from tundra.namei.org ([65.99.196.166]:40780 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752194Ab1AWXc6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jan 2011 18:32:58 -0500
Date: Mon, 24 Jan 2011 10:32:42 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        keyrings@linux-nfs.org, David Howells <dhowells@redhat.com>,
        David Safford <safford@watson.ibm.com>, Mimi Zohar <zohar@us.ibm.com>
Subject: Re: [PATCH 1/3] trusted-keys: rename trusted_defined files to
 trusted
In-Reply-To: <1295359633-4993-1-git-send-email-zohar@linux.vnet.ibm.com>
Message-ID: <alpine.LRH.2.00.1101241031500.30043@tundra.namei.org>
References: <1295359633-4993-1-git-send-email-zohar@linux.vnet.ibm.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Jan 2011, Mimi Zohar wrote:

> Rename trusted_defined.c and trusted_defined.h files to trusted.c and
> trust.h, respectively. Based on request from David Howells.
> 
> Signed-off-by: Mimi Zohar <zohar@us.ibm.com>


Applied to
git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6#next

(There was a clash with some other changes which David sent to Linus, 
which I fixed).

-- 
James Morris
<jmorris@namei.org>
