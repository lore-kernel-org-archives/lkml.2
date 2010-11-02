Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752179Ab0KBMix (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Nov 2010 08:38:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25168 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751822Ab0KBMit (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Nov 2010 08:38:49 -0400
Date: Tue, 2 Nov 2010 14:38:44 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v3 5/7] KVM: handle more completed apfs if possible
Message-ID: <20101102123844.GE7881@redhat.com>
References: <4CCE8143.3090105@cn.fujitsu.com>
 <4CCE822B.1070909@cn.fujitsu.com>
 <20101101092457.GY26191@redhat.com>
 <4CCFDB67.9050401@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CCFDB67.9050401@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 02, 2010 at 05:35:35PM +0800, Xiao Guangrong wrote:
> If it's no need to inject async #PF to PV guest we can handle
> more completed apfs at one time, so we can retry guest #PF
> as early as possible
> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Acked-by: Gleb Natapov <gleb@redhat.com>

--
			Gleb.
