Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757343Ab2IMKzF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 06:55:05 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:37454 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753811Ab2IMKzC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 06:55:02 -0400
MIME-Version: 1.0
In-Reply-To: <20120913045206.GB17105@core.coreip.homeip.net>
References: <1344895914-32127-1-git-send-email-vbocek@gmail.com>
	<20120905055218.GA24715@core.coreip.homeip.net>
	<CAOeGmboLCan-fX4sPPxS5jkyepxLTSnRgvdHJ0-edcH8UCQg+w@mail.gmail.com>
	<20120913045206.GB17105@core.coreip.homeip.net>
Date: Thu, 13 Sep 2012 12:55:01 +0200
Message-ID: <CAOeGmbp9MYNnXn0RYdsR4cLSV-3KhDjVzRQnL0mKTrQG1_j9GQ@mail.gmail.com>
Subject: Re: [PATCH 1/1] Input: joydev - fix axes values sent in initial js_event
From: Vojtech Bocek <vbocek@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/9/13, Dmitry Torokhov <dmitry.torokhov@gmail.com>:
> On Wed, Sep 05, 2012 at 10:09:57PM +0200, Vojtěch Boček wrote:
>
> This makes sense. Just to confirm - have you tried the patch and
> verified it works for you?
>
> Thanks.
>
> --
> Dmitry
>

Yes, I did. Only one thing is incorrect(?). When I plug the joystick in,
then open my test program, everything is okay, startup event has
 correct values. Then, I unplug the joystick and plug it in again
 quickly, after that, startup event has wrong values, but another
 normal axis event with correct values is fired immediately after.

I suppose it does not matter, because in the end, values are
 correct.  Felt worth mentioning, though.
