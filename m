Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760760Ab2JaUVO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 16:21:14 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:44825 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760682Ab2JaUVM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 16:21:12 -0400
Date: Thu, 1 Nov 2012 00:21:08 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Will Drewry <wad@chromium.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Pavel Emelyanov <xemul@parallels.com>
Subject: Re: [PATCH] proc: add "Seccomp" to status
Message-ID: <20121031202108.GB10588@moon>
References: <20121031200926.GA22988@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121031200926.GA22988@www.outflux.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 31, 2012 at 01:09:27PM -0700, Kees Cook wrote:
> Adds the seccomp mode to the /proc/$pid/status file so the state of
> seccomp can be externally examined.
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>

Reviewed-by: Cyrill Gorcunov <gorcunov@openvz.org>
