Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932422Ab0GOFJI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 01:09:08 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:38795 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932387Ab0GOFJG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 01:09:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=WMiUCWzsLnVrTotmA1pk2N1CQGv8re4C89KW3JYzrH/XAunhy8nAz74wzdZVBLXVS0
         +jCpAbf5rliMGM0XPe9FoLG4BNpujh2bXx408Qao190kd6z0QvbWpLQIOhTit0FzVXOD
         /D+BmS4xF9xS8KAFFEfjkSPFdCc31omlSF7Ok=
MIME-Version: 1.0
In-Reply-To: <20100714203919.GD6682@nuttenaction>
References: <4C3D94E3.9080103@wildgooses.com>
	<4C3DD5EB.9070908@tmr.com>
	<20100714.111553.104052157.davem@davemloft.net>
	<4C3E0684.5060409@wildgooses.com>
	<4C3E1B54.40604@hp.com>
	<20100714203919.GD6682@nuttenaction>
Date: Wed, 14 Jul 2010 22:09:04 -0700
Message-ID: <AANLkTikInXSrQ9Javof_Z4O1RY1Zvd4t5j6D1rwyfcYe@mail.gmail.com>
Subject: Re: Raise initial congestion window size / speedup slow start?
From: "H.K. Jerry Chu" <hkjerry.chu@gmail.com>
To: Hagen Paul Pfeifer <hagen@jauu.net>
Cc: Rick Jones <rick.jones2@hp.com>, Ed W <lists@wildgooses.com>,
        David Miller <davem@davemloft.net>, davidsen@tmr.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 14, 2010 at 1:39 PM, Hagen Paul Pfeifer <hagen@jauu.net> wrote:
> * Rick Jones | 2010-07-14 13:17:24 [-0700]:
>
>>There is an effort under way, lead by some folks at Google and
>>including some others, to get the RFC's enhanced in support of the
>>concept of larger initial congestion windows.  Some of the discussion
>>may be in the "tcpm" mailing list (assuming I've not gotten my
>>mailing lists confused).  There may be some previous discussion of
>>that work in the netdev archives as well.
>
> tcpm is the right mailing list but there is currently no effort to develop
> this topic. Why? Because is not a standardization issue, rather it is a

Please don't mislead. Raising the initcwnd is actively being pursued at IETF
right now. If not here, where else? It is following the same path where initcwnd
was first raised in late 90' through rfc2414/rfc3390.

IETF is not a standard organization just for protocol lawyers to play
word games.
It is responsible for solving real technical issues as well.

Jerry

> technical issue. You cannot rise the initial CWND and expect a fair behavior.
> This was discussed several times and is documented in several documents and
> RFCs.
>
> RFC 5681 Section 3.1. Google employees should start with Section 3. This topic
> pop's of every two months in netdev and until now I _never_ read a
> consolidated contribution.
>
> Partial local issues can already be "fixed" via route specific ip options -
> see initcwnd.
>
> HGN
>
>
>
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe netdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
