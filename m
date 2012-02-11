Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758371Ab2BKMWb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Feb 2012 07:22:31 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:51045 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754778Ab2BKMWa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Feb 2012 07:22:30 -0500
MIME-Version: 1.0
In-Reply-To: <20120210164529.44e5e7db@pyramind.ukuu.org.uk>
References: <20120210134929.12442.59041.stgit@bob.linux.org.uk>
	<20120210135253.12442.95497.stgit@bob.linux.org.uk>
	<CAJd=RBAYtrQZBB3LHX=9xFru=r1XAuZrm1kL1siMKvBmCuuO9A@mail.gmail.com>
	<20120210164529.44e5e7db@pyramind.ukuu.org.uk>
Date: Sat, 11 Feb 2012 20:22:28 +0800
Message-ID: <CAJd=RBCWCinPwnqeXwm5P0zecbe3o1T+10xNSttfvYMN0feu0Q@mail.gmail.com>
Subject: Re: [PATCH 3/6] sep: Add interfaces for the new functions
From: Hillf Danton <dhillf@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: greg@kroah.com, linux-kernel@vger.kernel.org, mark.a.allyn@intel.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q1BCMc8W025072

On Sat, Feb 11, 2012 at 12:45 AM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> On Fri, 10 Feb 2012 21:53:50 +0800
> Hillf Danton <dhillf@gmail.com> wrote:
>
> Sorry don't see what you are pointing out. It might help if you posted
> just the small bit in question ?

Hello Alan

>                if (1 == test_bit(SEP_LEGACY_SENDMSG_DONE_OFFSET,
>                                  &call_status->status)) {
> -                       dev_dbg(&sep->pdev->dev,
> -                               "[PID%d] dcb preparation needed before send msg\n",
> +                       dev_warn(&sep->pdev->dev,
> +                               "[PID%d] dcb prep needed before send msg\n",
>                                current->pid);
>                        error = -EPROTO;

Here error is assigned with -EPROTO,

>                        goto end_function;
>                }
>
>                if (!arg) {
> -                       dev_dbg(&sep->pdev->dev,
> -                               "[PID%d] dcb prep null arg\n", current->pid);
> -                       error = -EINVAL;
> +                       dev_warn(&sep->pdev->dev,
> +                               "[PID%d] dcb null arg\n", current->pid);
> +                       error = EINVAL;

why is EINVAL used then instead of -EINVAL?

Is this error case anything special from the above?
I guess it is typo.

Good weekend
Hillf

>                        goto end_function;
>                }
���{.n�+�������+%�����ݶ��w��{.n�+����{��G�����{ay�ʇڙ�,j��f���h��������z_�(�階�ݢj"���m������G������?����&���~��iO��z��v�^�m����������?�I�
