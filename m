Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752051Ab1INXzX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 19:55:23 -0400
Received: from tundra.namei.org ([65.99.196.166]:58198 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751277Ab1INXzV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 19:55:21 -0400
Date: Thu, 15 Sep 2011 09:55:18 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
cc: linux-security-module <linux-security-module@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PULL] encrypted-keys: please pull for security-testing next
In-Reply-To: <1316037440.2777.51.camel@localhost.localdomain>
Message-ID: <alpine.LRH.2.00.1109150954470.23372@tundra.namei.org>
References: <1316037440.2777.51.camel@localhost.localdomain>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Sep 2011, Mimi Zohar wrote:

> Hi James,
> 
> The previously posted "encrypted-keys: remove trusted-keys dependency"
> moved trusted keys to its own directory keys/encrypted-keys and removed
> the trusted-keys dependency.  Other than splitting this into two
> separate patches, nothing else has changed since posted.
> 
> Please pull the following 3 patches from the temporary repo:
> 
> The following changes since commit a8f7640963ada66c412314c3559c11ff6946c1a5:
> 
>   TOMOYO: Avoid race when retrying "file execute" permission check. (2011-09-14 08:27:07 +1000)
> 
> are available in the git repository at:
>   git://github.com/mzohar/linux-evm.git #next-evm


Thanks, pulled to 
git://selinuxproject.org/~jmorris/linux-security next

-- 
James Morris
<jmorris@namei.org>
