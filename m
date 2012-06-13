Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754054Ab2FMNi3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 09:38:29 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:33317 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752600Ab2FMNi1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 09:38:27 -0400
MIME-Version: 1.0
In-Reply-To: <1339589919.53487.YahooMailNeo@web111718.mail.gq1.yahoo.com>
References: <1339589919.53487.YahooMailNeo@web111718.mail.gq1.yahoo.com>
Date: Wed, 13 Jun 2012 21:38:26 +0800
Message-ID: <CAM_iQpXHXnHDnQZwYHwCWt=HxCA3K8EmJrikTNZryYfCPdeoPA@mail.gmail.com>
Subject: Re: logging on kernel panic
From: Cong Wang <xiyou.wangcong@gmail.com>
To: Mahmood Naderan <nt_mahmood@yahoo.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 13, 2012 at 8:18 PM, Mahmood Naderan <nt_mahmood@yahoo.com> wrote:
> Hi everybody
> If a system receives kernel panic during boot, will it be logged somewhere?
> In our diskless cluster, clients boot from an image located at /nfsroot
> Normally /nfsroot/var/log/syslog should contain messages. However
> on a kernel panic, there is no log in /nfsroot/var/log/syslog/
>

The kernel log may not hit /var/log/syslog when kernel panics,
try other more reliable way to get the kernel log, there are some
new ways to store the kernel log at panic/oops, pstore filesystem
is one of them.

As Alan mentioned, netconsole may work too.
