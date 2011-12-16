Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760236Ab1LPJ3w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 04:29:52 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:40386 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759876Ab1LPJ3q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 04:29:46 -0500
MIME-Version: 1.0
In-Reply-To: <4EEB0EFC.5000302@broadcom.com>
References: <4EEB0EFC.5000302@broadcom.com>
Date: Fri, 16 Dec 2011 11:29:45 +0200
Message-ID: <CAEnQRZA+Om=1VKpRQiSxvRzvkbicmsR=wsyskFu-WQ8HrbuM4Q@mail.gmail.com>
Subject: Re: unexpected taint message
From: Daniel Baluta <daniel.baluta@gmail.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, Dec 16, 2011 at 11:27 AM, Arend van Spriel <arend@broadcom.com> wrote:
> To whoever may know,
>
> Upon loading our driver module I get the following message:
>
> kernel: [  344.805106] Disabling lock debugging due to kernel taint
>
> What exactly are the criteria for tainting? Our driver locking strategy
> is something we want to refactor and having lock debugging during that
> transition may be a life safer.

Is your driver GPL licensed?

thanks,
Daniel.
