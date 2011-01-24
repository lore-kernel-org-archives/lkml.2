Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752870Ab1AXAYX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jan 2011 19:24:23 -0500
Received: from tundra.namei.org ([65.99.196.166]:50550 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752433Ab1AXAYV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jan 2011 19:24:21 -0500
Date: Mon, 24 Jan 2011 11:24:10 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Michal Schmidt <mschmidt@redhat.com>
cc: Rajiv Andrade <srajiv@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org
Subject: Re: [PATCH] TPM: Long default timeout fix
In-Reply-To: <20110120154603.2bdf5d9b@alice>
Message-ID: <alpine.LRH.2.00.1101241123290.30744@tundra.namei.org>
References: <1289596730-28966-1-git-send-email-srajiv@linux.vnet.ibm.com> <20110120154603.2bdf5d9b@alice>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Jan 2011, Michal Schmidt wrote:

> what is the status of this patch from Rajiv? It has been in Fedora
> kernels for some time, but I do not see it applied upstream:
> 
> On Fri, 12 Nov 2010 19:18:50 -0200 Rajiv Andrade wrote:
> > If duration variable value is 0 at this point, it's because
> > chip->vendor.duration wasn't filled by tpm_get_timeouts() yet.
> > This patch sets then the lowest timeout just to give enough
> > time for tpm_get_timeouts() to further succeed.
> > 
> > This fix avoids long boot times in case another entity attempts
> > to send commands to the TPM when the TPM isn't accessible.
> > 
> > Signed-off-by: Rajiv Andrade <srajiv@linux.vnet.ibm.com>

Applied to
git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6#for-linus

-- 
James Morris
<jmorris@namei.org>
