Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759915Ab0JZOul (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 10:50:41 -0400
Received: from smtp151.iad.emailsrvr.com ([207.97.245.151]:49457 "EHLO
	smtp151.iad.emailsrvr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759871Ab0JZOui (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 10:50:38 -0400
Message-ID: <4CC6EAB5.9020006@triadsys.com>
Date: Tue, 26 Oct 2010 10:50:29 -0400
From: Tom Vier <tom@triadsys.com>
Organization: Triad Systems Engineering, Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12) Gecko/20100913 Icedove/3.0.7
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Samuel Thibault <sthibault@debian.org>, 594089@bugs.debian.org,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Bug#594089: keyboard-configuration: caps lock keycode problem
References: <20100823154353.2805.13525.reportbug@tom.tse> <20100903235540.GA9149@const> <4C866913.3030201@triadsys.com> <4C8E6861.1070502@triadsys.com> <20101024144150.GV24091@const.famille.thibault.fr> <20101025045003.GA1438@core.coreip.homeip.net> <4CC58816.3090301@triadsys.com> <20101025180320.GA4725@const.famille.thibault.fr> <20101025182509.GA13929@core.coreip.homeip.net>
In-Reply-To: <20101025182509.GA13929@core.coreip.homeip.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/25/2010 02:25 PM, Dmitry Torokhov wrote:
> On Mon, Oct 25, 2010 at 08:03:20PM +0200, Samuel Thibault wrote:
>> Could you also post results when pressing the "favorite" and the "prev"
>> internet keys of your keyboard?
>>
>
> Actually, if these are all the events that evtest reports when pressing
> CapsLock then I am confused where the "favorites" ghost press is coming
> from... They are not emitted by the device. Do you have a funky keymap
> loaded somewhere? Also, was 'showkey -s' issued while in X or in the
> text console?

Console. I just ran it now and caps-lock has the same codes as 
"favorites" and right-shift has the same as "previous". So it's not an X 
problem.

--
Tom Vier <tom@triadsys.com>
Senior Net/Sys Admin
Triad Systems Engineering, Inc.
