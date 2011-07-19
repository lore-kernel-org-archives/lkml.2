Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752081Ab1GSGBV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 02:01:21 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:47799 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751092Ab1GSGBU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 02:01:20 -0400
MIME-Version: 1.0
In-Reply-To: <4D81708D.5090607@linux.vnet.ibm.com>
References: <4D81708D.5090607@linux.vnet.ibm.com>
Date: Tue, 19 Jul 2011 14:01:19 +0800
Message-ID: <CAGyNYUN9cGKx=xZM_5wOKObYxR2z13HzdvYo6OfcfVgrCxgJig@mail.gmail.com>
Subject: Re: [GIT PULL] TPM driver robustness fixes
From: Eugene Teo <eugeneteo@kernel.sg>
To: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
Cc: James Morris <jmorris@namei.org>,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Peter Huewe <huewe.external.infineon@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rajiv,

On Thu, Mar 17, 2011 at 10:23 AM, Rajiv Andrade
<srajiv@linux.vnet.ibm.com> wrote:
> Hi James,
>
> The following changes since commit 2e270d84223262a38d4755c61d55f5c73ea89e56:
>
>  Merge branch 'for-linus' of
> git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs-2.6 (2011-03-16
> 13:26:17 -0700)
>
> are available in the git repository at:
>
>  git://tpmdd.git.sourceforge.net/gitroot/tpmdd/tpmdd/ for-james
>
> Peter Huewe (3):

I think this one fell through the cracks.

Out of the three patches, only one is committed upstream:
[PATCH 1/3] char/tpm: Fix uninitialized usage of data buffer
1309d7afbed112f0e8e90be9af975550caa0076b

What happened to the other two?
[PATCH 2/3] char/tpm: Call tpm_transmit with correct size
[PATCH 3/3] char/tpm: zero buffer after copying to userspace

http://tpmdd.git.sourceforge.net/git/gitweb.cgi?p=tpmdd/tpmdd git repo
is gone too?

Eugene
