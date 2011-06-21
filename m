Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756897Ab1FUPy5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 11:54:57 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:53551 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753509Ab1FUPyz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 11:54:55 -0400
MIME-Version: 1.0
In-Reply-To: <201106211620.02065.arnd@arndb.de>
References: <1308640714-17961-1-git-send-email-ohad@wizery.com> <201106211620.02065.arnd@arndb.de>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Tue, 21 Jun 2011 09:54:35 -0600
X-Google-Sender-Auth: A6KF8YkX-yv6TeNkekiwCjN_E-0
Message-ID: <BANLkTikwA=_jHmnb7CT9aAmJ_GnLXZ9OAw@mail.gmail.com>
Subject: Re: [RFC 0/8] Introducing a generic AMP/IPC framework
To: Arnd Bergmann <arnd@arndb.de>
Cc: Ohad Ben-Cohen <ohad@wizery.com>, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        akpm@linux-foundation.org, Brian Swetland <swetland@google.com>,
        davinci-linux-open-source 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Rusty Russell <rusty@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 21, 2011 at 8:20 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> Hi Ohad,
>
> On Tuesday 21 June 2011, Ohad Ben-Cohen wrote:
>
>> This patch set adds a generic AMP/IPC framework which makes it possible to
>> control (power on, boot, power off) and communicate (simply send and receive
>> messages) with those remote processors.
>
> This looks really nice overall, but I don't currently have time for a
> more in-depth review. My feeling is that you are definitely on the right
> track here, and the plans you list as TODO to continue are all good.

Second that.  I'm happy to see the shift over to virtio, I think that
is the right direction overall.  I'll try to carve out some time for a
detailed review.

g.
