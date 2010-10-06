Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757043Ab0JFJF4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 05:05:56 -0400
Received: from ozlabs.org ([203.10.76.45]:38891 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756973Ab0JFJFx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 05:05:53 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Dave Young <hidave.darkstar@gmail.com>
Subject: Re: [PATCH] kvm: add oom notifier for virtio balloon
Date: Wed, 6 Oct 2010 19:35:44 +1030
User-Agent: KMail/1.13.2 (Linux/2.6.32-24-generic; KDE/4.4.2; i686; ; )
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, avi@redhat.com,
        Anthony Liguori <anthony@codemonkey.ws>
References: <20101005124521.GA2602@darkstar>
In-Reply-To: <20101005124521.GA2602@darkstar>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201010061935.45010.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Oct 2010 11:15:21 pm Dave Young wrote:
> Balloon could cause guest memory oom killing and panic.
> 
> Add oom notify to leak some memory and retry fill balloon after 5 minutes.

Have you tried registering a shrinker?  See mm.h.

Thanks,
Rusty.
