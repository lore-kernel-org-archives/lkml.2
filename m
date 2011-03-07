Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754918Ab1CGRIU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 12:08:20 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:36259 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752887Ab1CGRIS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 12:08:18 -0500
MIME-Version: 1.0
In-Reply-To: <AANLkTi=h0MkySh+VjrdohLzTB-NqSmmZOKcRtGRyHTg=@mail.gmail.com>
References: <1299385050-13674-1-git-send-email-bgat@billgatliff.com>
	<1299385050-13674-2-git-send-email-bgat@billgatliff.com>
	<4D745D1F.2070808@fastmail.fm>
	<AANLkTi=h0MkySh+VjrdohLzTB-NqSmmZOKcRtGRyHTg=@mail.gmail.com>
Date: Mon, 7 Mar 2011 11:08:17 -0600
Message-ID: <AANLkTikbW-FApSyx0FyVUCYHUG=0HS8JHpoNha0EdiZH@mail.gmail.com>
Subject: Re: [PWM v6 1/3] PWM: Implement a generic PWM framework
From: Bill Gatliff <bgat@billgatliff.com>
To: Jack Stone <jwjstone@fastmail.fm>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jack:

On Mon, Mar 7, 2011 at 10:35 AM, Bill Gatliff <bgat@billgatliff.com> wrote:
> On Sun, Mar 6, 2011 at 10:20 PM, Jack Stone <jwjstone@fastmail.fm> wrote:
>>> +menuconfig GENERIC_PWM
>>> +     tristate "PWM Support"
>>> +     help
>>> +       Enables PWM device support implemented via a generic
>>> +       framework.  If unsure, say N.
>>> +
>>
>> Does this need help text? Can't we just select GENERIC_PWM for the
>> drivers / users that need it?
>
> That would be my preference, actually.  I'll see if I can do that at
> the next review.

Actually, I take that back. Unlike gpiolib, the PWM API isn't
mandatory.  So I think I'll leave this as a menuconfig.


b.g.
-- 
Bill Gatliff
bgat@billgatliff.com
