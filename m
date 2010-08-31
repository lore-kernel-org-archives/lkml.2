Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755305Ab0HaTc5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 15:32:57 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:49020 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752718Ab0HaTc4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 15:32:56 -0400
MIME-Version: 1.0
In-Reply-To: <4C7D248A.2080507@redhat.com>
References: <1282950052.3284.110.camel@dhcp231-106.rdu.redhat.com>
 <AANLkTi=aEdKM_hunJmPzXxPqkrbok+_C6QUKf8v=Q+18@mail.gmail.com>
 <1283210070.3284.139.camel@dhcp231-106.rdu.redhat.com> <4C7CC107.1050304@redhat.com>
 <4C7D0DAD.9030505@redhat.com> <4C7D141A.9060102@redhat.com>
 <4C7D1868.3090701@redhat.com> <1283267765.3284.150.camel@dhcp231-106.rdu.redhat.com>
 <4C7D1E1B.4020700@redhat.com> <1283268367.3284.154.camel@dhcp231-106.rdu.redhat.com>
 <4C7D248A.2080507@redhat.com>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Tue, 31 Aug 2010 21:32:39 +0200
Message-ID: <AANLkTikhc1Nu5PsQqzKL0PXY3juOxwuPOsu0ZKvzfCJ3@mail.gmail.com>
Subject: Re: selinux vs devtmpfs (vs udev)
To: Harald Hoyer <harald@redhat.com>
Cc: Eric Paris <eparis@redhat.com>, Daniel J Walsh <dwalsh@redhat.com>,
        linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov, greg@kroah.com,
        sds@tycho.nsa.gov
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 31, 2010 at 17:49, Harald Hoyer <harald@redhat.com> wrote:
> https://bugzilla.redhat.com/show_bug.cgi?id=575128#c14
> https://bugzilla.redhat.com/attachment.cgi?id=442223&format=raw
>
> udev/udev-node.c
>
> +                       /* set selinux file context on add events */
> +                       if (strcmp(udev_device_get_action(dev), "add") == 0)
> +                               udev_selinux_lsetfilecon(udev, file, mode);

I can't access these bugs.

Does that makes sense/work for you?
  http://git.kernel.org/?p=linux/hotplug/udev.git;a=commitdiff;h=326c5fc3ea684825629eccaf33a548759162a539

Kay
