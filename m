Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753361Ab2HAJde (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 05:33:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52945 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751858Ab2HAJdc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 05:33:32 -0400
Message-ID: <5018F7E6.4020909@redhat.com>
Date: Wed, 01 Aug 2012 12:33:26 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
CC: mtosatti@redhat.com, kvm@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: KVM segfaults with 3.5 while installing ubuntu 12.04
References: <5017C8A0.60506@profihost.ag> <5017F19E.4070308@redhat.com> <501817C9.6090405@profihost.ag> <5018EC7D.9090702@redhat.com> <5018F5BB.9070500@profihost.ag>
In-Reply-To: <5018F5BB.9070500@profihost.ag>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/01/2012 12:24 PM, Stefan Priebe - Profihost AG wrote:
> Hi,
> 
> ok i found a faster way to trigger this. Just boot the ubuntu rescue
> system.
> 
> So here are 3 backtraces from booting the rescue system:
> http://pastebin.com/raw.php?i=xCy2pEcP
> 
> To me they all look the same.

They are.  What version of qemu are you using?


-- 
error compiling committee.c: too many arguments to function


