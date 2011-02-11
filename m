Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752918Ab1BKHBa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 02:01:30 -0500
Received: from tundra.namei.org ([65.99.196.166]:37977 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752126Ab1BKHB3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 02:01:29 -0500
Date: Fri, 11 Feb 2011 18:01:14 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Chris Wright <chrisw@sous-sol.org>
cc: linux-kernel@vger.kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>,
        Eric Paris <eparis@redhat.com>, Don Dutile <ddutile@redhat.com>
Subject: Re: [PATCH 0/2] pci: refer to LSM when accessing device dependent
 config space
In-Reply-To: <1297318312-14309-1-git-send-email-chrisw@sous-sol.org>
Message-ID: <alpine.LRH.2.00.1102111800560.28805@tundra.namei.org>
References: <1297318312-14309-1-git-send-email-chrisw@sous-sol.org>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 Feb 2011, Chris Wright wrote:

> Short patch series to make sure LSM gets visibility into attempt to
> access device dependent config space.  Fixes a buglet I introduced in
> de139a3 ("pci: check caps from sysfs file open to read device dependent
> config space")
> 
> Chris Wright (2):
>   security: add cred argument to security_capable()
>   pci: use security_capable() when checking capablities during config
>     space read

Applied to
git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6#for-linus



-- 
James Morris
<jmorris@namei.org>
