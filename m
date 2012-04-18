Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752734Ab2DRC6a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 22:58:30 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:46513 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751765Ab2DRC61 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 22:58:27 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LRH.2.02.1204181239110.23644@tundra.namei.org>
References: <1334692161-6834-1-git-send-email-wad@chromium.org>
	<1334692161-6834-2-git-send-email-wad@chromium.org>
	<alpine.LRH.2.02.1204181239110.23644@tundra.namei.org>
Date: Tue, 17 Apr 2012 21:58:25 -0500
Message-ID: <CABqD9hZr+Z5LD7DO3qb4EOqY0Omayc7wfxwjX-xYX7Ze-XiBqw@mail.gmail.com>
Subject: Re: [PATCH 2/2] seccomp: fix build warnings when there is no CONFIG_SECCOMP_FILTER
From: Will Drewry <wad@chromium.org>
To: James Morris <jmorris@namei.org>
Cc: linux-kernel@vger.kernel.org, sfr@canb.auug.org.au,
        linux-security-module@vger.kernel.org, Eric Paris <eparis@redhat.com>,
        James Morris <james.l.morris@oracle.com>,
        Kees Cook <keescook@chromium.org>,
        Serge Hallyn <serge.hallyn@canonical.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 17, 2012 at 9:39 PM, James Morris <jmorris@namei.org> wrote:
> Both applied to
> git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/linux-security.git next
>

Thanks!
