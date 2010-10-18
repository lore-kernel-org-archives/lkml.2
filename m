Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753548Ab0JRHFx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 03:05:53 -0400
Received: from web37607.mail.mud.yahoo.com ([209.191.87.90]:29301 "HELO
	web37607.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752900Ab0JRHFw convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 03:05:52 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=Oh3CLs5+Ss9sws26oHqq3/39BNxJuZ7mXfOcZIhRdxTjZtUQN89xHHAx25IQcb+tkKWXaoiSp48gr9wbPxQLipQQGz1EOhsIvpNnJkL8uAR7eb+eKTM4YQx+O2x10eOYlgGO85ge2CFrMTRnt7Si37BJ1ZTl/gaSL99sC/hdmcA=;
Message-ID: <451805.21484.qm@web37607.mail.mud.yahoo.com>
X-YMail-OSG: mGkCUGgVM1na8zjVY65ijgAKGIVJlAumA5691zRkAbh3Dqw
 vj3u6_P2awsGGU_s1_MzPF6OKUXBtzTAVOPbv4edf4g9XsI99ehjxfdC9CLz
 8RvBAHCrBn7YEAFKOIMOesG5jRep5cQThavD.omkifs9UJkp.WFsg7iXbUV8
 N_u4qE7MrtNFAXSR5kUXkBzS2E_CHV.lqGcf2yVWWj.HgfJmx4anuCqG2._Z
 bPQMYkg946qwTi6RrCnSlCGCmTd3GVjN48YOn7AYRHes9Xoq3YhMH4AIY4v.
 yFLKLatEV6VPiHWiwzBCSr91MRIL4Rr_Na609mkfASV8LsUCSQ6CBTljCMmo
 E6IWVJlSRVuCD1fEE26o1qyru9Ak-
X-Mailer: YahooMailClassic/11.4.9 YahooMailWebService/0.8.106.282862
Date: Mon, 18 Oct 2010 00:05:51 -0700 (PDT)
From: Alex Dubov <oakad@yahoo.com>
Subject: Re: [PATCH 0/6] Results of my work on memorystick subsystem
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1287356101.25869.1.camel@maxim-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--- On Sun, 17/10/10, Maxim Levitsky <maximlevitsky@gmail.com> wrote:

> > 
> > Here is a result of lot of work I did improving the
> memorystick
> > subsystem and its drivers.
> Comments?
> Flames?
> Suggestions?
> 

My opinion is, that in the current form your patches are completely
unworkable.

I suggest a following approach, consisting of 3 clearly separated steps:

Step 1 - a set of functional patches to jmicron driver.
Step 2 - a set of functional patches to mspro driver.
Step 3 - common code elimination (the whole thing is not that large, it
can tolerate some code duplication).

When we done with this, we can discuss whatever cosmetic changes you want
to do (moving stuff around and , possibly, renaming, which I don't see as
necessary at all).






      
