Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756345Ab1I2NUn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 09:20:43 -0400
Received: from msux-gh1-uea02.nsa.gov ([63.239.65.40]:63290 "EHLO
	msux-gh1-uea02.nsa.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752687Ab1I2NUm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 09:20:42 -0400
Subject: Re: [PATCH] Smack: fix domain transfer issues
From: Stephen Smalley <sds@tycho.nsa.gov>
To: Jarkko Sakkinen <jarkko.sakkinen@intel.com>
Cc: Casey Schaufler <casey@schaufler-ca.com>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org
In-Reply-To: <alpine.DEB.2.02.1109291109070.3006@jsakkine-mobl>
References: <1317206909-24443-1-git-send-email-jarkko.sakkinen@intel.com>
	 <1317222904.20139.20.camel@moss-pluto>
	 <alpine.DEB.2.02.1109291109070.3006@jsakkine-mobl>
Content-Type: text/plain; charset="UTF-8"
Organization: National Security Agency
Date: Thu, 29 Sep 2011 09:20:36 -0400
Message-ID: <1317302436.4079.22.camel@moss-pluto>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-09-29 at 11:26 +0300, Jarkko Sakkinen wrote:
> MNT_NOSUID should be checked.

Doubtful, as Smack and capabilities are completely orthogonal, right?
Even for SELinux, the nosuid check is a bit of a nuisance.

>  Also, I'll plan to
> implement permission check for ptrace but in the
> scope of this patch.

Still no transition or entrypoint checks, open file revalidation, parent
death signal clearing, ...?

-- 
Stephen Smalley
National Security Agency

