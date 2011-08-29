Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753981Ab1H2O5G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 10:57:06 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:49550 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753757Ab1H2O5B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 10:57:01 -0400
Subject: Re: [PATCH v1 1/2] encrypted-keys: remove trusted-keys dependency
From: Sasha Levin <levinsasha928@gmail.com>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: linux-security-module@vger.kernel.org, James Morris <jmorris@namei.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Arnaud Lacombe <lacombar@gmail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        David Safford <safford@watson.ibm.com>, Mimi Zohar <zohar@us.ibm.com>
In-Reply-To: <1314629313-11980-1-git-send-email-zohar@linux.vnet.ibm.com>
References: <1314629313-11980-1-git-send-email-zohar@linux.vnet.ibm.com>
Content-Type: text/plain; charset="us-ascii"
Date: Mon, 29 Aug 2011 17:56:52 +0300
Message-ID: <1314629812.29761.21.camel@sasha>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-08-29 at 10:48 -0400, Mimi Zohar wrote:
> Encrypted keys are decrypted/encrypted using either a trusted-key or,
> for those systems without a TPM, a user-defined key.  This patch
> removes the trusted-keys and TCG_TPM dependencies.
> 
> Changelog v1:
> - Fixed encrypted-keys move from security/keys to security/keys/encrypted-keys
> - Removed trailing blank line
> 
> Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
> ---

Please look into using 'git mv' and the '--find-renames' option of git
format-patch.

You just want to mark the files as moved, without ruining the entire
history of the old files.

-- 

Sasha.

