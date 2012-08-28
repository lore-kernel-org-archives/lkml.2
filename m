Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752443Ab2H1OKv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2012 10:10:51 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:48311 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752108Ab2H1OKu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2012 10:10:50 -0400
MIME-Version: 1.0
In-Reply-To: <20120827215356.GA27961@www.outflux.net>
References: <20120827215356.GA27961@www.outflux.net>
Date: Tue, 28 Aug 2012 10:10:48 -0400
X-Google-Sender-Auth: 71zpXGO1gR_ZdSWboS8a6pBKrPo
Message-ID: <CAFtxgO5QSYwQcHCbaXoT6pauTYPGpNBC31vufcAOUb5i7c-UfA@mail.gmail.com>
Subject: Re: [PATCH] Remove CONFIG_EXPERIMENTAL
From: Jeff Garzik <jgarzik@pobox.com>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, Dave Jones <davej@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 27, 2012 at 5:53 PM, Kees Cook <keescook@chromium.org> wrote:
> This config item has not carried much meaning for a while now and is
> almost always enabled by default. Remove it and adjust various config
> logic and documentation.

It does have meaning...  !CONFIG_EXPERIMENTAL means more stable.  In
the past things would get CONFIG_EXPERIMENTAL until they've been tried
in the field or otherwise hit some goal in the developer's mind.

Is this a practical distinction?  Probably not, as the markers often
go unmaintained...

    Jeff
