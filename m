Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751646Ab0LYGs4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Dec 2010 01:48:56 -0500
Received: from LUNGE.MIT.EDU ([18.54.1.69]:37830 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751125Ab0LYGsz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Dec 2010 01:48:55 -0500
Date: Fri, 24 Dec 2010 22:48:51 -0800
From: Andres Salomon <dilinger@queued.net>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Daniel Drake <dsd@laptop.org>, Paul Fox <pgf@laptop.org>,
        linux-kernel@vger.kernel.org
Subject: Re: MFD cell structure and sharing of resources
Message-ID: <20101224224851.61942d75@queued.net>
In-Reply-To: <20101224104518.GB27832@sortiz-mobl>
References: <AANLkTinrF-dxiw7OQ=dMhQPgKSqS6yYfDzdcnHfhMtyf@mail.gmail.com>
	<20101216103550.GA5946@sortiz-mobl>
	<AANLkTi=ypose5day4=ypV8_SsiFq4vf9vqZh-OWret0x@mail.gmail.com>
	<20101224104518.GB27832@sortiz-mobl>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Dec 2010 11:45:19 +0100
Samuel Ortiz <sameo@linux.intel.com> wrote:
[...]
> 
> One more thing: What about my proposal of defining IO routines from
> the MFD driver, and using those from your subdevices driver ?
> 
>

Having looked at the twl4030 driver, I do like that approach.  Is this
something you want to see for cs5535 only, or are enough other mfd
drivers doing this that you'd like the mfd framework itself to define
hooks for cell/resource sharing?
