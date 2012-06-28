Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755722Ab2F1WuI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 18:50:08 -0400
Received: from plane.gmane.org ([80.91.229.3]:53035 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753529Ab2F1WuG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 18:50:06 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Alex Elsayed <eternaleye+usenet@gmail.com>
Subject: Re: UEFI Secure boot using qemu-kvm
Date: Thu, 28 Jun 2012 11:36:31 -0700
Message-ID: <jsi87f$gkb$1@dough.gmane.org>
References: <1340818445.3175.73.camel@dabdike.int.hansenpartnership.com> <20120627181503.GA7775@srcf.ucam.org> <1340825704.3175.88.camel@dabdike.int.hansenpartnership.com> <20120627193806.GA10091@srcf.ucam.org> <1340826809.3175.89.camel@dabdike.int.hansenpartnership.com> <20120627200100.GA10300@srcf.ucam.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8Bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: rain.gmane.org
User-Agent: KNode/4.8.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Garrett wrote:

> On Wed, Jun 27, 2012 at 08:53:29PM +0100, James Bottomley wrote:
>> /usr/include/efi/x86_64/efibind.h:88:1: error: unknown type name
>> ‘uint64_t’
> 
> Ok, so some difference in toolchains is pulling in stdint.h for me but
> not for you.
> 

If James is on GCC 4.7 and you are on 4.6, that would explain it - 4.7 
dropped some implicit #includes AIUI.

