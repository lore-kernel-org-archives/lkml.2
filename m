Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754050Ab1B1NZD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 08:25:03 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53904 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753955Ab1B1NZC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 08:25:02 -0500
Subject: Re: [PATCH] expose kvmclock upper msr set.
From: Glauber Costa <glommer@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <4D6A409E.9010107@redhat.com>
References: <1298483054-1665-1-git-send-email-glommer@redhat.com>
	 <4D6A409E.9010107@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat
Date: Mon, 28 Feb 2011 10:24:55 -0300
Message-ID: <1298899495.15736.321.camel@mothafucka.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-02-27 at 14:16 +0200, Avi Kivity wrote:
> On 02/23/2011 07:44 PM, Glauber Costa wrote:
> > We've been supporting kvmclock MSRs in the 0x4b564d00-0x4b564dff range
> > for a while now, but we're not exposing it yet, meaning nobody is using it.
> > This simple patch takes care of that.
> 
> We're exposing them via KVM_GET_SUPPORTED_CPUID, leaf KVM_CPUID_FEATURES.
> 
Our userspace does not really use it, and rely on the capability list.
Historically, we've been relying on the capabilities mechanism to
indicate what exists and what does not. 

