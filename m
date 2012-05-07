Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756153Ab2EGKax (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 06:30:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60789 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754378Ab2EGKav (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 06:30:51 -0400
Message-ID: <4FA7A458.3030508@redhat.com>
Date: Mon, 07 May 2012 13:30:48 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Joerg Roedel <joerg.roedel@amd.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: X86: Add mmx movq emulation
References: <1336132029-13523-1-git-send-email-joerg.roedel@amd.com> <4FA64D85.1000609@redhat.com> <20120507102841.GI4687@amd.com>
In-Reply-To: <20120507102841.GI4687@amd.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/07/2012 01:28 PM, Joerg Roedel wrote:
> On Sun, May 06, 2012 at 01:08:05PM +0300, Avi Kivity wrote:
> > This is already in (cbe2c9d30, e59717550e).  Are you looking at master
> > instead of next?
>
> Btw. your mail about the new git-workflow states something about an
> auto-next branch. But I don't see that branch in the KVM tree (looking
> at git://git.kernel.org/pub/scm/virt/kvm/kvm.git). 

We "forgot" to generate it.

> Is there another
> branch that contains all fixes and everything for the next merge window?
> Basically I am looking for a branch which has the new master and next
> merged.

Right.  I'll get my scripts to generate it.  (btw:  auto-next =
merge(upstream, master, next)).

-- 
error compiling committee.c: too many arguments to function

