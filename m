Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932259Ab1CIQTL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 11:19:11 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:62097 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752285Ab1CIQTH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 11:19:07 -0500
MIME-Version: 1.0
In-Reply-To: <4D76717E.2000900@fastmail.fm>
References: <1299385050-13674-1-git-send-email-bgat@billgatliff.com>
	<1299385050-13674-2-git-send-email-bgat@billgatliff.com>
	<4D745D1F.2070808@fastmail.fm>
	<AANLkTi=h0MkySh+VjrdohLzTB-NqSmmZOKcRtGRyHTg=@mail.gmail.com>
	<AANLkTikbW-FApSyx0FyVUCYHUG=0HS8JHpoNha0EdiZH@mail.gmail.com>
	<4D76717E.2000900@fastmail.fm>
Date: Wed, 9 Mar 2011 10:19:06 -0600
Message-ID: <AANLkTi=BXC6uX7DaNGs_cH9h_1xdPCkdmQ8CDqCXwVgf@mail.gmail.com>
Subject: Re: [PWM v6 1/3] PWM: Implement a generic PWM framework
From: Bill Gatliff <bgat@billgatliff.com>
To: Jack Stone <jwjstone@fastmail.fm>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jack:


On Tue, Mar 8, 2011 at 12:12 PM, Jack Stone <jwjstone@fastmail.fm> wrote:
> It's up to you, of course, but I don't see why I would want to choose.

It isn't that I want users to be able to choose between GENERIC_PWM
and the platform-specific PWM; it's that I want to have the option of
doing PWM, or not.  Once a machine/platform is converted over to
GENERIC_PWM, there won't be any going back.

> It makes life much easier for users if they only have to support one way
> of talking to PWM devices and any device can be connected to any user,
> with appropriate connections provided by platform data.

Right.  That's the vision, in fact.  But I don't have the manpower to
do a complete conversion to GENERIC_PWM all at once, so I'm trying to
take it in stages.  Introduce the generic API first, and then switch
machines/platforms over to it one at a time.

> It seems much simpler to me to always use it in appropriate
> drivers/users and therefore if the person configuring the kernel does
> not have to know anything new and the support will only be included if
> needed.

Right.

It isn't that I want users to be able to decide between the "new PWM"
and "old PWM" APIs; it's that I want them to be able to turn PWM
support on or off at compile time.


b.g.
-- 
Bill Gatliff
bgat@billgatliff.com
