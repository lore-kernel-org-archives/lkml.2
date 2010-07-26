Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753969Ab0GZOAp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 10:00:45 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:37772 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753001Ab0GZOAn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 10:00:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=o17+IcbXocHOEIwR1rOL7oHwZomfMc5ESZndC8p0SBNIP999W/lQygO7t/VrvjEDlx
         IObM7MhJLdOOpYhRQbF0tL2f0YItecQcgOOcAd2l/sJtBANXbMB1qG7tDV/N+cCjBdkC
         jofZ9yyX/cZT31jtxQ7YDDbZPYuG6udPgF+Jc=
Subject: Re: [RFC] [PATCH procfs] Add process age
From: Davidlohr Bueso <dave.bueso@gmail.com>
Reply-To: dave.bueso@gmail.com
To: Andi Kleen <andi@firstfloor.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
In-Reply-To: <87fwz6it0e.fsf@basil.nowhere.org>
References: <1279907271.4335.3.camel@cowboy> <20100723183549.GA10518@x200>
	 <1279910830.1851.5.camel@cowboy>  <87fwz6it0e.fsf@basil.nowhere.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 26 Jul 2010 09:57:48 -0400
Message-ID: <1280152668.2212.1.camel@cowboy>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-07-26 at 09:47 +0200, Andi Kleen wrote:
> Davidlohr Bueso <dave.bueso@gmail.com> writes:
> 
> > On Fri, 2010-07-23 at 21:35 +0300, Alexey Dobriyan wrote:
> >> On Fri, Jul 23, 2010 at 01:47:51PM -0400, Davidlohr Bueso wrote:
> >> > This patch exports a process's age, in seconds, adding a /proc/#/age file.
> >> 
> >> What for?
> >
> > I have not found any straight way to get the run time of a processes,
> > without having to interpret the start_time entry in /proc/#/stat and
> > manually subtract the uptime from it.
> 
> That sounds like something an user space program should simply do.
> Perhaps you can add it as a new optional "-o" field in "ps" ?
> 
True, but there are also many other no-so-useful files under /proc that
can also be replaced by userspace apps.

Davidlohr

