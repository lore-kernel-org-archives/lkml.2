Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932105Ab0FUPwB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 11:52:01 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:43736 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756749Ab0FUPwA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 11:52:00 -0400
Date: Mon, 21 Jun 2010 08:51:40 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Weedy <weedy2887@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Entropy poolsize
Message-Id: <20100621085140.19dda646.randy.dunlap@oracle.com>
In-Reply-To: <AANLkTil7mInflmvrvVQmOx7xrNVFAY7GtqQiGobHMTT2@mail.gmail.com>
References: <AANLkTil7mInflmvrvVQmOx7xrNVFAY7GtqQiGobHMTT2@mail.gmail.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090206.4C1F8A9E.0184:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Jun 2010 09:58:16 -0400 Weedy wrote:

> I know grsecurity has a option for this but I don't want to patch my
> kernel with it at this time. I have been poking around random.c but I
> can't seem to figure out where .poolsize is assigned it's value and
> how to increase it.
> 
> If someone could point it out that would be nice.
> 
> Thank you for your time.
> --

Do you mean this one in drivers/char/random.c or something else?

static int sysctl_poolsize = INPUT_POOL_WORDS * 32;

It's a sysctl, so it is tunable.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
