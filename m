Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754324Ab2B0TfB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 14:35:01 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58509 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751738Ab2B0TfA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 14:35:00 -0500
Message-ID: <1330371297.2542.19.camel@localhost>
Subject: Re: [PATCH] seccomp: remove duplicated failure logging
From: Eric Paris <eparis@redhat.com>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, Will Drewry <wad@chromium.org>
Date: Mon, 27 Feb 2012 14:34:57 -0500
In-Reply-To: <20120227191230.GA2831@www.outflux.net>
References: <20120227191230.GA2831@www.outflux.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-02-27 at 11:12 -0800, Kees Cook wrote:
> This consolidates the seccomp filter error logging path and adds more
> details to the audit log.
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>

Thanks, I'll take a look, I'm on a new crusade to remove duplicate
information from the audit system and you might be my first victim   :)

-Eric

