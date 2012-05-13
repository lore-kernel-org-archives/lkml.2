Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752471Ab2EMSJl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2012 14:09:41 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:57696 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752023Ab2EMSJk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2012 14:09:40 -0400
MIME-Version: 1.0
In-Reply-To: <1968221.ZfIukAANIQ@localhost>
References: <1968221.ZfIukAANIQ@localhost>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 13 May 2012 11:09:18 -0700
X-Google-Sender-Auth: MdUxRb-r3vnUdvISxfATkTbo3g0
Message-ID: <CA+55aFx8a5fno3TSZgSuhpkq5CVuPwzY4XMkfTuX=gTZh_g7EA@mail.gmail.com>
Subject: Re: Linux-3.4-rc7
To: =?ISO-8859-2?Q?Pawe=B3_Sikora?= <pluto@pld-linux.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 13, 2012 at 8:15 AM, Paweł Sikora <pluto@pld-linux.org> wrote:
<
> i've found one more issue in install log:
>
> (...)
>  DEPMOD  3.4.0-rc7
> WARNING: /lib/modules/3.4.0-rc7/kernel/drivers/net/macvlan.ko needs unknown symbol skb_set_dev
> WARNING: /lib/modules/3.4.0-rc7/kernel/net/8021q/8021q.ko needs unknown symbol skb_set_dev

You have old modules lying around or some patch mis-applied in your
tree. skb_set_dev() doesn't exist in the -rc7 tree any more (it was
introduced and then reverted again).

                   Linus
