Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752665Ab1F1XUi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 19:20:38 -0400
Received: from tundra.namei.org ([65.99.196.166]:44974 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751379Ab1F1XUc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 19:20:32 -0400
Date: Wed, 29 Jun 2011 09:18:20 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
cc: linux-security-module@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Roberto Sassu <roberto.sassu@polito.it>,
        Tyler Hicks <tyhicks@linux.vnet.ibm.com>
Subject: Re: [PULL] ecryptfs-keys: please pull for security-testing next
In-Reply-To: <1309298162.2760.33.camel@localhost.localdomain>
Message-ID: <alpine.LRH.2.00.1106290918070.14211@tundra.namei.org>
References: <1309298162.2760.33.camel@localhost.localdomain>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Jun 2011, Mimi Zohar wrote:

> Hi James,
> 
> Please pull the ecryptfs encrypted key extension patches.
> 
> The following changes since commit 4d67431f80b1b822f0286afc9123ee453eac7334:
> 
>   KEYS: Don't return EAGAIN to keyctl_assume_authority() (2011-06-14 15:03:29 +1000)
> 
> are available in the git repository at:
>   git://git.kernel.org/pub/scm/linux/kernel/git/zohar/ima-2.6.git next-ecryptfs-keys

Thanks, applied.


-- 
James Morris
<jmorris@namei.org>
