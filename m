Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756103Ab2EIAqH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 20:46:07 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:46094 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755728Ab2EIAqE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 20:46:04 -0400
MIME-Version: 1.0
In-Reply-To: <4FA9B7BF.90502@xenotime.net>
References: <20120508181531.072fdc5fefa60d852e784587@canb.auug.org.au>
 <4FA948B9.20600@xenotime.net> <1336518821.728.1.camel@mop>
 <4FA9ABD6.6030006@xenotime.net> <1336520271.728.4.camel@mop> <4FA9B7BF.90502@xenotime.net>
From: Kay Sievers <kay@vrfy.org>
Date: Wed, 9 May 2012 02:45:41 +0200
Message-ID: <CAPXgP133n_RL=PfdmTNWcJwFtvDBPey1OF6rKc0DJkHSYW0_Mw@mail.gmail.com>
Subject: Re: linux-next: Tree for May 8 (printk)
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 9, 2012 at 2:18 AM, Randy Dunlap <rdunlap@xenotime.net> wrote:
> On 05/08/2012 04:37 PM, Kay Sievers wrote:

> drivers/char/mem.c:858:2: error: implicit declaration of function 'printk_emit'
>
>        printk_emit(facility, level, NULL, 0, "%s", line);

You need the whole series, there is no  printk_emit() in that file anymore.

Kay
