Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752641Ab1CQAxL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 20:53:11 -0400
Received: from tundra.namei.org ([65.99.196.166]:59174 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752330Ab1CQAxH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 20:53:07 -0400
Date: Thu, 17 Mar 2011 11:52:26 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: John Johansen <john.johansen@canonical.com>
cc: Kees Cook <kees.cook@canonical.com>, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v5 0/3] security: Yama LSM
In-Reply-To: <4D80F59D.6000603@canonical.com>
Message-ID: <alpine.LRH.2.00.1103171120590.31128@tundra.namei.org>
References: <1300237742-23415-1-git-send-email-kees.cook@canonical.com> <20110316013527.GQ5466@outflux.net> <4D80F59D.6000603@canonical.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Mar 2011, John Johansen wrote:

> On 03/15/2011 06:35 PM, Kees Cook wrote:
> > On Tue, Mar 15, 2011 at 06:08:59PM -0700, Kees Cook wrote:
> >> This is an update of the Yama Linux Security Module.
> >>
> >> Now that there are attempts at permitting multiple active LSM modules,
> >> Yama should be reconsidered.
> > 
> Well not just that multiple active LSM modules are being reconsidered, but
> that YAMA is now being picked and used by a couple of other distros.

Distros should not be shipping out of tree code and then using that as a 
reason to ask for it to be merged.

We've obviously not reached a consensus on how to approach these security 
enhancements, so be aware that the final outcome upstream may not follow 
the approach that distros have already taken.

My preference is to see core security functionality incorporated into the 
core kernel where possible.

The purpose of LSM is to allow the configuration of different enhanced 
access control schemes (i.e. beyond Unix DAC).  Ad-hoc security 
enhancements which are not part of a coherent & distinct access control 
scheme should not be dropped into LSM simply because LSM has hooks in the 
right places, has security in the name, or because core developers pushed 
back on the code elsewhere.

Personally, I'd like to see the kernel offer as much hardening as possible 
for the general case, but this kind of work especially needs to be 
incorporated with full buy-in from core developers.



- James
-- 
James Morris
<jmorris@namei.org>
