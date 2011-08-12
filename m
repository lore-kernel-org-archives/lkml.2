Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753939Ab1HLCr7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 22:47:59 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:48481 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753852Ab1HLCr5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 22:47:57 -0400
MIME-Version: 1.0
In-Reply-To: <CAMk6uBnwL8Y+QFRYKux6LxXT1zkgEKzMtUhNEjD6UFL5tARYiA@mail.gmail.com>
References: <1312256727-13906-1-git-send-email-sonic.adi@gmail.com>
 <CAMjpGUeeNZ_S9hgz8pi-uTnJdcUjemuOusNa=fJ9muPPaSQLMQ@mail.gmail.com> <CAMk6uBnwL8Y+QFRYKux6LxXT1zkgEKzMtUhNEjD6UFL5tARYiA@mail.gmail.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Thu, 11 Aug 2011 22:47:36 -0400
Message-ID: <CAMjpGUcqXE2Z2z9Ve5gSymjPcyCM9Hbgy3oFFYAxBkhwfEgeEw@mail.gmail.com>
Subject: Re: [PATCH v2] serial:bfin_uart: Put TX IRQ in individual platform resource.
To: real mz <realmz6@gmail.com>
Cc: Sonic Zhang <sonic.adi@gmail.com>, Alan Cox <alan@linux.intel.com>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        uclinux-dist-devel@blackfin.uclinux.org,
        Sonic Zhang <sonic.zhang@analog.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 11, 2011 at 22:39, real mz wrote:
> you mean the uart wakeup fix?

yarp.  seems like Sonic's refactor broke it to need your patch.  or i
misread things (i only glanced).
-mike
