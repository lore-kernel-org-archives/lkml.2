Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755297Ab1K1TfO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 14:35:14 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:36072 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755191Ab1K1TfL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 14:35:11 -0500
MIME-Version: 1.0
In-Reply-To: <20111128191658.GA6028@albatros>
References: <1319672956-17114-1-git-send-email-keescook@chromium.org>
	<20111128191658.GA6028@albatros>
Date: Mon, 28 Nov 2011 11:35:10 -0800
X-Google-Sender-Auth: ihNQ2rP7CGUSWdkDs738h0quaPA
Message-ID: <CAGXu5j+=j7Gy+D0wzZ44NPAK1PYyp1gHU-GQQOBCLi4fRc9UmQ@mail.gmail.com>
Subject: Re: [RFC -resend] Make Yama pid_ns aware
From: Kees Cook <keescook@chromium.org>
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        kernel-hardening@lists.openwall.com,
        "Serge E. Hallyn" <serge@hallyn.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 28, 2011 at 11:16 AM, Vasiliy Kulikov <segoon@openwall.com> wrote:
> As Yama's sysctls are about defining a security policy for the system,
> it is reasonable to define it per container in case of LXC containers
> (or out-of-tree alternatives like OpenVZ).  In my opinion they belong
> to pid namespace.  With per-pid_ns sysctls it is possible to create
> multiple containers with different ptrace, /tmp, etc. policies.
> [...]
> Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>

Thanks! I'll include this in the next Yama patch set.

Acked-by: Kees Cook <keescook@chromium.org>

-Kees

-- 
Kees Cook
ChromeOS Security
