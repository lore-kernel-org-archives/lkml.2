Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755287Ab1FVJfJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 05:35:09 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:38431 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753849Ab1FVJfI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 05:35:08 -0400
X-IronPort-AV: E=Sophos;i="4.65,405,1304294400"; 
   d="scan'208";a="6419252"
Subject: Re: [PATCH x86 kvm] Fix register corruption in pvclock_scale_delta
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Avi Kivity <avi@redhat.com>
CC: Zachary Amsden <zamsden@redhat.com>, kvm <kvm@vger.kernel.org>,
        Linux-kernel <linux-kernel@vger.kernel.org>,
        Ulrich Obergfell <uobergfe@redhat.com>
In-Reply-To: <4DFDEF2A.7050307@redhat.com>
References: <4DF97D6C.2080900@redhat.com>  <4DFDEF2A.7050307@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Citrix Systems, Inc.
Date: Wed, 22 Jun 2011 10:35:02 +0100
Message-ID: <1308735302.6920.172.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-06-19 at 15:44 +0300, Avi Kivity wrote:
> On 06/16/2011 06:50 AM, Zachary Amsden wrote:
> > The 128-bit multiply in pvclock.h was missing an output constraint for 
> > EDX which caused a register corruption to appear.

Was there any particular symptom associated with corruption at that
particular point or just general badness?

>   Thanks to Ulrich 
> > for diagnosing the EDX corruption and Avi for providing this fix 
> > (which now I am sending back to you Avi..)
> 
> Applied and queued, thanks.

Seems like a stable candidate also?

Ian.

