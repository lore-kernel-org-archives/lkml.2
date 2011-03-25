Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755562Ab1CYXnB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 19:43:01 -0400
Received: from smtp-out.google.com ([74.125.121.67]:39820 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755456Ab1CYXnA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 19:43:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=D6JS2lqtK6AUEZNiXDKq5VoIBhQBZS4XjbLHAq4McZpDk/F+dBKPzcTzvJFI2GqvdO
         QpCyG3B3gWBdDAHLhzSw==
MIME-Version: 1.0
In-Reply-To: <20110324133244.acffd99a.randy.dunlap@oracle.com>
References: <20110324133244.acffd99a.randy.dunlap@oracle.com>
From: Mike Waychison <mikew@google.com>
Date: Fri, 25 Mar 2011 16:42:36 -0700
Message-ID: <AANLkTikLSVpw73r_g++_oRs=nTjYf5WmH=XNjjp8o5uo@mail.gmail.com>
Subject: Re: [PATCH] watchdog: fix nv_tco section mismatch
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>,
        Wim Van Sebroeck <wim@iguana.be>, linux-watchdog@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 24, 2011 at 1:32 PM, Randy Dunlap <randy.dunlap@oracle.com> wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
>
> Fix section mismatch warning:
> Mark the called nv_tco_getdevice() as __devinit, just like its caller.

This looks fine.

I can't seem to reproduce the warning on my end however, compiling
this as a built-in nor as a module.  How do I trigger a difference
between __init and __devinit?
