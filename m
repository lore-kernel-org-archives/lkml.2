Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756439Ab2AQX3r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 18:29:47 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:64732 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756404Ab2AQX3o convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 18:29:44 -0500
MIME-Version: 1.0
In-Reply-To: <1326411506-16894-3-git-send-email-wad@chromium.org>
References: <1326411506-16894-1-git-send-email-wad@chromium.org>
	<1326411506-16894-3-git-send-email-wad@chromium.org>
Date: Tue, 17 Jan 2012 18:29:43 -0500
Message-ID: <CACLa4pthnooQn8-kecPxHw7nVdHfx+0Vx5BpucLugMc9XN+dqg@mail.gmail.com>
Subject: Re: [PATCH v3 3/3] Documentation: prctl/seccomp_filter
From: Eric Paris <eparis@parisplace.org>
To: Will Drewry <wad@chromium.org>
Cc: linux-kernel@vger.kernel.org, keescook@chromium.org,
        john.johansen@canonical.com, serge.hallyn@canonical.com,
        coreyb@linux.vnet.ibm.com, pmoore@redhat.com, eparis@redhat.com,
        djm@mindrot.org, torvalds@linux-foundation.org, segoon@openwall.com,
        rostedt@goodmis.org, jmorris@namei.org, scarybeasts@gmail.com,
        avi@redhat.com, penberg@cs.helsinki.fi, viro@zeniv.linux.org.uk,
        luto@mit.edu, mingo@elte.hu, akpm@linux-foundation.org, khilman@ti.com,
        borislav.petkov@amd.com, amwang@redhat.com, oleg@redhat.com,
        ak@linux.intel.com, eric.dumazet@gmail.com, gregkh@suse.de,
        dhowells@redhat.com, daniel.lezcano@free.fr,
        linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org,
        olofj@chromium.org, mhalcrow@google.com, dlaor@redhat.com,
        corbet@lwn.net, alan@lxorguk.ukuu.org.uk
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 12, 2012 at 6:38 PM, Will Drewry <wad@chromium.org> wrote:

> +#ifndef PR_ATTACH_SECCOMP_FILTER
> +#      define PR_ATTACH_SECCOMP_FILTER 36
> +#endif


The example code here uses 36, but the real code I believe uses 37.
Can we get these in sync?  Thanks!
