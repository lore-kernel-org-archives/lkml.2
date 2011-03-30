Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932852Ab1C3ToK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 15:44:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17273 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932792Ab1C3ToI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 15:44:08 -0400
Subject: Re: [tpmdd-devel] TPM chip prevents machine from suspending
From: Eric Paris <eparis@redhat.com>
To: Stefan Berger <stefanb@linux.vnet.ibm.com>
Cc: Rajiv Andrade <srajiv@linux.vnet.ibm.com>,
        tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-Reply-To: <4D91F4BB.5090708@linux.vnet.ibm.com>
References: <20110328100846.0ba2e039@tlielax.poochiereds.net>
	 <4D90C472.3090908@linux.vnet.ibm.com>
	 <20110328141241.06a435f8@tlielax.poochiereds.net>
	 <20110328154543.1bb979fd@tlielax.poochiereds.net>
	 <4D91157F.2020502@linux.vnet.ibm.com>
	 <20110329080856.1726dfaa@tlielax.poochiereds.net>
	 <4D91CF9D.3050500@linux.vnet.ibm.com> <4D91ED0C.8070503@linux.vnet.ibm.com>
	 <4D91F4BB.5090708@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 30 Mar 2011 15:43:58 -0400
Message-ID: <1301514238.561.9.camel@unknown001a4b0c2895>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-03-29 at 11:03 -0400, Stefan Berger wrote:

> - send  a command to the TPM upon resume and if TPM response returns 
> with error code 38 set a flag and don't send TPM_SaveState() upon the 
> next suspend; log this case; the TPM becomes unusable; machine will 
> suspend a 2nd time

I assume there is no reasonable way to detect this particular piece of
broken BIOS/hardware?  If not I think this sounds like the best option
to me.  If the TPM doesn't work after resume not much we can do other
than accept it doesn't work and move along.....

