Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755047Ab2BGKXZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 05:23:25 -0500
Received: from mail-lpp01m020-f174.google.com ([209.85.217.174]:61002 "EHLO
	mail-lpp01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754629Ab2BGKXW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 05:23:22 -0500
MIME-Version: 1.0
X-Originating-IP: [85.143.161.18]
In-Reply-To: <4F30E62B02000078000717EB@nat28.tlf.novell.com>
References: <4F2C06A00200007800071071@nat28.tlf.novell.com>
 <d86f0be9-1530-47bd-b3fd-8c251e563b25@default> <4F2F998202000078000714CD@nat28.tlf.novell.com>
 <e871af1b-8003-4d3d-8fde-ea40545ff9fe@default> <4F3012B602000078000716AB@nat28.tlf.novell.com>
 <20120206170224.GD23240@phenom.dumpdata.com> <4F30E62B02000078000717EB@nat28.tlf.novell.com>
From: Vasiliy Tolstov <v.tolstov@selfip.ru>
Date: Tue, 7 Feb 2012 14:23:05 +0400
X-Google-Sender-Auth: Ef884wPbZwgvk8CRL36eaEiAne4
Message-ID: <CACaajQt0MDNAN51g6AuYZn7ApwvuVgn+=GdyPNDJYVh95ecD0g@mail.gmail.com>
Subject: Re: [Xen-devel] [PATCH] xen/tmem: cleanup
To: Jan Beulich <JBeulich@suse.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>, xen-devel@lists.xensource.com,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/2/7 Jan Beulich <JBeulich@suse.com>:

>
> As outlined above, it is possible, but I'm not certain it is a good idea
> to have balloon_set_new_target() exported. If you think that's
> acceptable, I can certainly put together a patch doing that (on top
> of the one here, and probably not immediately).
>
> Jan

Exporting balloon_set_new_target can be grate feature to do own
modules for balloon memory inside xen guest, becouse some times we
need more realtime control from dom0 for memory growing speed inside
guest.


-- 
Vasiliy Tolstov,
Clodo.ru
e-mail: v.tolstov@selfip.ru
jabber: vase@selfip.ru
