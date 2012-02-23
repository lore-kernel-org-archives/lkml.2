Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757258Ab2BWXgK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 18:36:10 -0500
Received: from ist.d-labs.de ([213.239.218.44]:39313 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753521Ab2BWXgI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 18:36:08 -0500
Date: Fri, 24 Feb 2012 00:35:59 +0100
From: Florian Mickler <florian@mickler.org>
To: Herbert Poetzl <herbert@13thfloor.at>
Cc: Linux Kernel ML <linux-kernel@vger.kernel.org>, JBottomley@parallels.com,
        linux-scsi@vger.kernel.org
Subject: Re: 3.2.x Regression for SAS Controller on Dell C6100
Message-ID: <20120224003559.41dea166@schatten>
In-Reply-To: <20120131180949.GT29272@MAIL.13thfloor.at>
References: <20120131180949.GT29272@MAIL.13thfloor.at>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.8; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[adding some cc's from that area ]
On Tue, 31 Jan 2012 19:09:49 +0100
Herbert Poetzl <herbert@13thfloor.at> wrote:

> 
> Greetings!
> 
> I'm seeing a regression on a Dell C6100 machine with
> 3.2.x kernels, where the second disk (in a raid setup)
> is not properly recogniced and so the raid drops into
> degraded mode
> 
> the same hardware works fine with 3.1.x kernels and
> older
> 
> attached the dmesg output of the bootup for a working
> and a failing kernel
> 
> thanks in advance,
> Herbert
> 
