Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753031Ab2G0JD3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 05:03:29 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:35726 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752942Ab2G0JCx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 05:02:53 -0400
MIME-Version: 1.0
In-Reply-To: <gir4rxk7c2.fsf@mx10.gouders.net>
References: <gir4rxk7c2.fsf@mx10.gouders.net>
Date: Fri, 27 Jul 2012 17:02:53 +0800
Message-ID: <CAM_iQpX3EFnoW=Vh2hgJwNPr-whJhcUctCyv_+afFB8DrnHRsQ@mail.gmail.com>
Subject: Re: [RFC PATCH] netconsole.txt: "nc" needs "-p" to specify the
 listening port
From: Cong Wang <xiyou.wangcong@gmail.com>
To: Dirk Gouders <gouders@et.bocholt.fh-gelsenkirchen.de>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 27, 2012 at 2:35 PM, Dirk Gouders
<gouders@et.bocholt.fh-gelsenkirchen.de> wrote:
> Hi Jesse,
>
> I would like to ask you to check if the documentation of "nc" in
> netconsole.txt is still correct.  I tried two different netcat packages
> and both require "-p" to specify the listening port.  I am wondering if
> that changed after the use of "nc" has been documented.

On Fedora 16, `nc -u -l <port number>` works fine.
