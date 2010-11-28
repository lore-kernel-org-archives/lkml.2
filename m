Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753173Ab0K1V5I (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Nov 2010 16:57:08 -0500
Received: from tundra.namei.org ([65.99.196.166]:41542 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751772Ab0K1V5F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Nov 2010 16:57:05 -0500
Date: Mon, 29 Nov 2010 08:56:34 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        keyrings@linux-nfs.org, linux-crypto@vger.kernel.org,
        David Howells <dhowells@redhat.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        David Safford <safford@watson.ibm.com>,
        Rajiv Andrade <srajiv@linux.vnet.ibm.com>
Subject: Re: [PATCH v1.5 0/5] keys: trusted and encrypted keys
In-Reply-To: <1290552635-3356-1-git-send-email-zohar@linux.vnet.ibm.com>
Message-ID: <alpine.LRH.2.00.1011290856070.15604@tundra.namei.org>
References: <1290552635-3356-1-git-send-email-zohar@linux.vnet.ibm.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Nov 2010, Mimi Zohar wrote:

> Mimi Zohar (5):
>   lib: hex2bin converts ascii hexadecimal string to binary
>   tpm: add module_put wrapper
>   key: add tpm_send command
>   keys: add new trusted key-type
>   keys: add new key-type encrypted

Applied to
git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6#next

-- 
James Morris
<jmorris@namei.org>
