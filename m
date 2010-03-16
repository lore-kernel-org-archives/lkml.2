Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937487Ab0CPHPS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 03:15:18 -0400
Received: from mail-pz0-f200.google.com ([209.85.222.200]:64455 "EHLO
	mail-pz0-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756111Ab0CPHPL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 03:15:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=ngAep1zabaczOzRJ2awtmSQkckyFIHxw1f9G2V33C/ejfLHIrd2yMkXXOhhARg0OC8
         3f7LT5sMueTat3kkQ0NoGJ22yI26l0rPSrZxZ7iotHBZubONfbG4JtWsnck9IMep9PMq
         oXtIebCyH0fEdjCwGcfHDjAinRSjdzpdAWcD0=
MIME-Version: 1.0
In-Reply-To: <84144f021003152358r41a79ccaxb18cf6368911266@mail.gmail.com>
References: <4B990496.4020002@kernel.org> <4B9F08AC.9030904@kernel.org>
	 <20100316061718.GA22651@elte.hu>
	 <84144f021003152358r41a79ccaxb18cf6368911266@mail.gmail.com>
Date: Tue, 16 Mar 2010 09:15:10 +0200
Message-ID: <b6fcc0a1003160015j2926b2a2w4e7808939c4144d6@mail.gmail.com>
Subject: Re: [RFC] remove implicit slab.h inclusion from percpu.h
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Ingo Molnar <mingo@elte.hu>, Tejun Heo <tj@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Christoph Lameter <cl@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 16, 2010 at 8:58 AM, Pekka Enberg <penberg@cs.helsinki.fi> wrote:
> We should avoid creating tree-wide breakage for this kind of cleanups.

This is done by compile testing, not by being smartass.
