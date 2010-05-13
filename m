Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932979Ab0EMUT7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 16:19:59 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:61850 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932862Ab0EMUTx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 16:19:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=syRNQo9IJ+vuvXrLTRqCCzGfjNiWAv7N9/qhID3wqxJaZlB8D4aznBzK0EG+YDcr+V
         Yz6EUtrInV5C6ky9mFEbLJWlhR7gBdXP2GChppvGQ6ujfxn+Fl9G/sAdjgSJ7wf5M628
         yCaKi70KiCer96nhtEPZFu8yRrZ1TGtpcss64=
MIME-Version: 1.0
In-Reply-To: <AANLkTikWgHQBbLP7n6l7f5I676GsElDnO8VmlaEdtc6G@mail.gmail.com>
References: <1273669541.3086.24.camel@localhost>
	 <j2n6599ad831005121201za5fd85bpfc4fa2304a81acaf@mail.gmail.com>
	 <AANLkTilLXWEYHJZCoNk1Tb4P8qgjK-zoVZSg1pDhR-3I@mail.gmail.com>
	 <h2z6599ad831005121220h7956eb62yeea13626093b4a6e@mail.gmail.com>
	 <AANLkTikyXpXKhyy2oZxAF5ums2go2qie0ShOGt2dtHBH@mail.gmail.com>
	 <m2x6599ad831005121236ufa1bff7fz78423b1fb6b513e7@mail.gmail.com>
	 <AANLkTimxO3xWmr8jgyiwsLNyqTJ-4OWJ4zNROC9SE7XH@mail.gmail.com>
	 <o2j6599ad831005131312jfef915b5g9cc7c96761742977@mail.gmail.com>
	 <AANLkTikWgHQBbLP7n6l7f5I676GsElDnO8VmlaEdtc6G@mail.gmail.com>
Date: Thu, 13 May 2010 22:19:51 +0200
Message-ID: <AANLkTimlaSxZ2pH2AxdwdIEp5r2VYvauHMh22PuFvTXa@mail.gmail.com>
Subject: Re: [PATCH/RFC] Have sane default values for cpusets
From: Dhaval Giani <dhaval.giani@gmail.com>
To: Paul Menage <menage@google.com>
Cc: balbir@linux.vnet.ibm.com, peterz@infradead.org, lennart@poettering.net,
       jsafrane@redhat.com, tglx@linutronix.de, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Default for root being "true" should work. Anything else, and you
> still require the programmer to know about cpuset and setting that
> flag to true.
>

To be honest, I don't see an easy way out of this. I think it is more
reasonable to have the change since a lot more users are benefited by
it. And in most cases, where they are broken, those applications do
require some specialist work, and so it should be reasonable to expect
the administrator to set the variable to false at mount time.

Dhaval
