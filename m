Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932856Ab0KLUZn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 15:25:43 -0500
Received: from mail-pv0-f174.google.com ([74.125.83.174]:50134 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932832Ab0KLUZl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 15:25:41 -0500
From: Kevin Hilman <khilman@deeprootsystems.com>
To: Andrei Emeltchenko <andrei.emeltchenko.news@gmail.com>
Cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2] OMAP: Serial: Define OMAP uart MDR1 register definitions
Organization: Deep Root Systems, LLC
References: <1289484812-17278-1-git-send-email-Andrei.Emeltchenko.news@gmail.com>
	<87hbfnx2zw.fsf@deeprootsystems.com>
	<AANLkTimL25m4X0Apynis-H7g7FVDLU7Cw8mV+q2fptK8@mail.gmail.com>
Date: Fri, 12 Nov 2010 12:25:38 -0800
In-Reply-To: <AANLkTimL25m4X0Apynis-H7g7FVDLU7Cw8mV+q2fptK8@mail.gmail.com>
	(Andrei Emeltchenko's message of "Fri, 12 Nov 2010 09:51:11 +0200")
Message-ID: <87k4kiqofx.fsf@deeprootsystems.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrei Emeltchenko <andrei.emeltchenko.news@gmail.com> writes:

> Hi,
>
> On Thu, Nov 11, 2010 at 6:02 PM, Kevin Hilman
> <khilman@deeprootsystems.com> wrote:
>> Emeltchenko Andrei <Andrei.Emeltchenko.news@gmail.com> writes:
>>
>>> From: Andrei Emeltchenko <andrei.emeltchenko@nokia.com>
>>>
>>> Define MDR1 register serial definitions used in serial and
>>> bluetooth drivers. Remove magic numbers there.
>>
>> Remove magic numbers where?  This patch doesn't remove anything.
>
> We have code which is not yet upstream, it will come through Bluetooth
> subtree at some point, I am also going to remove magic in
> omapX/serial.c drivers in the next patches.
>
> Do you think I need to add those patches?

Not necessarly, but the comment should be a little more clear.
Something "subsequent patches will remove...."

Kevin

