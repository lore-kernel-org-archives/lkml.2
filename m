Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753376Ab1AJDCB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jan 2011 22:02:01 -0500
Received: from tundra.namei.org ([65.99.196.166]:55206 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752423Ab1AJDB6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jan 2011 22:01:58 -0500
Date: Mon, 10 Jan 2011 13:59:41 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Roberto Sassu <roberto.sassu@polito.it>
cc: linux-security-module@vger.kernel.org, keyrings@linux-nfs.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        zohar@linux.vnet.ibm.com, dhowells@redhat.com, safford@watson.ibm.com,
        ramunno@polito.it, tyhicks@linux.vnet.ibm.com, kirkland@canonical.com
Subject: Re: [RFC][PATCH v2 3/6] encrypted-keys: add key format support
In-Reply-To: <1293533302-22868-4-git-send-email-roberto.sassu@polito.it>
Message-ID: <alpine.LRH.2.00.1101101358310.21511@tundra.namei.org>
References: <1293533302-22868-1-git-send-email-roberto.sassu@polito.it> <1293533302-22868-4-git-send-email-roberto.sassu@polito.it>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Dec 2010, Roberto Sassu wrote:

> This patch introduces a new parameter, called 'format', that defines the
> format of data stored by encrypted keys. The 'default' format identifies
> encrypted keys containing only the symmetric key, while other formats can
> be defined to support additional information. The 'format' parameter is
> written in the datablob produced by commands 'keyctl print' or
> 'keyctl pipe' and is integrity protected by the HMAC.
> 
> Signed-off-by: Roberto Sassu <roberto.sassu@polito.it>

You need to include any Acked-by etc. when you resend patches.

Mimi acked several of these, at least.


-- 
James Morris
<jmorris@namei.org>
