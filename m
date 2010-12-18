Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932092Ab0LRR7x (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Dec 2010 12:59:53 -0500
Received: from webhosting01.bon.m2soft.com ([195.38.20.32]:42384 "EHLO
	webhosting01.bon.m2soft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757105Ab0LRR7v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Dec 2010 12:59:51 -0500
Date: Sat, 18 Dec 2010 18:59:22 +0100
From: Nicolas Kaiser <nikai@nikai.net>
To: Tejun Heo <tj@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Duncan Sands <duncan.sands@free.fr>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH UPDATED 5/6] speedtch: don't abuse struct delayed_work
Message-ID: <20101218185922.525ad45c@absol.kitzblitz>
In-Reply-To: <4D0CE22F.7090409@kernel.org>
References: <20101216213005.GA5781@kroah.com>
 <1292172499-21633-6-git-send-email-tj@kernel.org>
 <1292172499-21633-1-git-send-email-tj@kernel.org>
 <20101217145117.75a28ae0@absol.kitzblitz>
 <4D0CE22F.7090409@kernel.org>
Organization: -
X-Face: "fF&[w2"Nws:JNH4'g|:gVhgGKLhj|X}}&w&V?]0=,7n`jy8D6e[Jh=7+ca|4~t5e[ItpL5
 N'y~Mvi-vJm`"1T5fi1^b!&EG]6nW~C!FN},=$G?^U2t~n[3;u\"5-|~H{-5]IQ2
X-Mailer: Claws Mail (Linux)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Tejun Heo <tj@kernel.org>:
> speedtch directly uses the internal timer and work members of a struct
> delayed_work.  Use a separate work item and timer instead.
> 
> * Nicolas Kaiser discovered that timer init was missing.  Fixed.

> Can you please test this one?  Thanks.

Works for me, thanks!

Tested-by: Nicolas Kaiser <nikai@nikai.net>

I'm about to replace this device, and will have to return it
to my ISP in about a fortnight. Until then I can perform
further tests if needed.

Best regards,
Nicolas Kaiser
