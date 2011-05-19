Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934685Ab1ESUai (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 16:30:38 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:50678 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933813Ab1ESUaf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 16:30:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=uW4ZIQ7+SIALBO2NeslHDI8hFhnipQv7XMwT+N1Ye0T5Xuov3G4WVPQIPFwho9WCEI
         4RP3q1i9eVE+cML01r7vj0KKWTcTbiPJoelFcqwMDvgGsaw8KHmj5X1tkhofVA35GkoN
         5pedxSFW5DPMkP5RkJHCTFwl11zo1sT2COas0=
MIME-Version: 1.0
In-Reply-To: <20110519.152703.1327182804872376183.davem@davemloft.net>
References: <BANLkTimSZEbnNVzi3UvBFndHp25S0ow7YQ@mail.gmail.com>
 <1456193D-84D1-46E2-B930-8FD0A5B8C409@comsys.rwth-aachen.de>
 <BANLkTikZasOVfr2zTfXVjPqQsnzy9Hk5uA@mail.gmail.com> <20110519.152703.1327182804872376183.davem@davemloft.net>
From: tsuna <tsunanet@gmail.com>
Date: Thu, 19 May 2011 13:30:15 -0700
Message-ID: <BANLkTinzTN=w9213+pCvBWuT5af7L7bKfg@mail.gmail.com>
Subject: Re: [PATCH] tcp: Implement a two-level initial RTO as per draft RFC 2988bis-02.
To: David Miller <davem@davemloft.net>
Cc: alexander.zimmermann@comsys.rwth-aachen.de, hagen@jauu.net,
        kuznet@ms2.inr.ac.ru, pekkas@netcore.fi, jmorris@namei.org,
        yoshfuji@linux-ipv6.org, kaber@trash.net, eric.dumazet@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 19, 2011 at 12:27 PM, David Miller <davem@davemloft.net> wrote:
> So using SCTP as an example of "see we do this already over here" is a
> non-starter.  Don't do it.

Fair enough.  I hope that the "there's no one-size-fits-all solution"
argument has more weight than "hey SCTP does it".  :)

-- 
Benoit "tsuna" Sigoure
Software Engineer @ www.StumbleUpon.com
