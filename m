Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755565Ab1HUQRL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Aug 2011 12:17:11 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:53132 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754135Ab1HUQRK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Aug 2011 12:17:10 -0400
MIME-Version: 1.0
X-Originating-IP: [97.79.165.138]
In-Reply-To: <CABUK1agNHcS8zB2RKPRg0LO8WRe3Z72CWyO+V1UY9M_+V6VO9Q@mail.gmail.com>
References: <1312989517-28604-1-git-send-email-pavan_savoy@ti.com>
	<CABUK1agNHcS8zB2RKPRg0LO8WRe3Z72CWyO+V1UY9M_+V6VO9Q@mail.gmail.com>
Date: Sun, 21 Aug 2011 11:17:09 -0500
Message-ID: <CABUK1agSHWTYrRV-EKv4EYpz7Shscnp6azSh68kaUFWDtvrSMg@mail.gmail.com>
Subject: Re: [PATCH 0/8] drivers:misc: ti-st: fixes
From: Pavan Savoy <pavan_savoy@sify.com>
To: linux-kernel@vger.kernel.org, Greg KH <greg@kroah.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 15, 2011 at 12:03 PM, Pavan Savoy <pavan_savoy@sify.com> wrote:
> On Wed, Aug 10, 2011 at 10:18 AM,  <pavan_savoy@ti.com> wrote:
>> From: Pavan Savoy <pavan_savoy@ti.com>

greg,

Please review...



> Greg,
>
> Resent, this time seems to have appeared properly ... So please review.
>
>
>> resending with fixed up commit messages.
>>
>> Pavan Savoy (7):
>>  drivers:misc: ti-st: avoid a misleading dbg msg
>>  drivers:misc:ti-st: platform hooks for chip states
>>  drivers:misc: ti-st: reinit completion on ver read
>>  drivers:misc: ti-st: reinit completion before send
>>  drivers:misc: ti-st: wait for completion at fail
>>  drivers:misc: ti-st: free skb on firmware download
>>  drivers:misc: ti-st: fix unexpected UART close
>>
>> Vijay Badawadagi (1):
>>  drivers:misc: ti-st: fail-safe on wrong pkt type
>>
>>  drivers/misc/ti-st/st_core.c |   10 +++++++++-
>>  drivers/misc/ti-st/st_kim.c  |   33 +++++++++++++++++++++++++++++++++
>>  drivers/misc/ti-st/st_ll.c   |   19 +++++++++++++++++++
>>  include/linux/ti_wilink_st.h |   27 ++++++++++++++++++++++++++-
>>  4 files changed, 87 insertions(+), 2 deletions(-)
>>
>> --
>> 1.7.4.1
>>
>>
>
