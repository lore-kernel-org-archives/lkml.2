Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754650Ab2ATSVB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 13:21:01 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:53767 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753738Ab2ATSU4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 13:20:56 -0500
MIME-Version: 1.0
In-Reply-To: <20120120140444.GC13157@x2.net.home>
References: <20120120140444.GC13157@x2.net.home>
From: Denys Vlasenko <vda.linux@googlemail.com>
Date: Fri, 20 Jan 2012 19:20:33 +0100
Message-ID: <CAK1hOcNget=-MjeejiYGo5Vkigq9ey1o7sD2peO+tDGdk3TU9g@mail.gmail.com>
Subject: Re: /etc/fstab.d yes or not
To: Karel Zak <kzak@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        util-linux@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 20, 2012 at 3:04 PM, Karel Zak <kzak@redhat.com> wrote:
>  BTW, systemd allows to define addition mountpoints in
>  systemd.mount(5) unit file(s), so we already have additional place
>  for fstab stuff...

systemd needs a large blunt object be stuck into its eye.

systemd was supposed to be an init replacement.
Its continuing attempts to infiltrate entire system
are very worrying.

$ ls -l /lib/systemd/systemd*
-rwxr-xr-x. 1 root root  22068 Nov  2 00:41 /lib/systemd/systemd-ac-power
-rwxr-xr-x. 1 root root  38656 Nov  2 00:41 /lib/systemd/systemd-binfmt
-rwxr-xr-x. 1 root root  30356 Nov  2 00:41 /lib/systemd/systemd-cgroups-agent
-rwxr-xr-x. 1 root root  51072 Nov  2 00:41 /lib/systemd/systemd-cryptsetup
-rwxr-xr-x. 1 root root  26328 Nov  2 00:41 /lib/systemd/systemd-detect-virt
-rwxr-xr-x. 1 root root  42856 Nov  2 00:41 /lib/systemd/systemd-fsck
-rwxr-xr-x. 1 root root  63576 Nov  2 00:41 /lib/systemd/systemd-hostnamed
-rwxr-xr-x. 1 root root  38644 Nov  2 00:41 /lib/systemd/systemd-initctl
-rwxr-xr-x. 1 root root  38668 Nov  2 00:41 /lib/systemd/systemd-kmsg-syslogd
-rwxr-xr-x. 1 root root  75776 Nov  2 00:41 /lib/systemd/systemd-localed
-rwxr-xr-x. 1 root root 186724 Nov  2 00:41 /lib/systemd/systemd-logind
-rwxr-xr-x. 1 root root  34552 Nov  2 00:41 /lib/systemd/systemd-modules-load
-rwxr-xr-x. 1 root root  30436 Nov  2 00:41 /lib/systemd/systemd-quotacheck
-rwxr-xr-x. 1 root root  30392 Nov  2 00:41 /lib/systemd/systemd-random-seed
-rwxr-xr-x. 1 root root  51148 Nov  2 00:41
/lib/systemd/systemd-readahead-collect
-rwxr-xr-x. 1 root root  38756 Nov  2 00:41
/lib/systemd/systemd-readahead-replay
-rwxr-xr-x. 1 root root  34520 Nov  2 00:41 /lib/systemd/systemd-remount-api-vfs
-rwxr-xr-x. 1 root root  26216 Nov  2 00:41 /lib/systemd/systemd-reply-password
-rwxr-xr-x. 1 root root  59328 Nov  2 00:41 /lib/systemd/systemd-shutdown
-rwxr-xr-x. 1 root root  38668 Nov  2 00:41 /lib/systemd/systemd-shutdownd
-rwxr-xr-x. 1 root root  34508 Nov  2 00:41
/lib/systemd/systemd-stdout-syslog-bridge
-rwxr-xr-x. 1 root root  38664 Nov  2 00:41 /lib/systemd/systemd-sysctl
-rwxr-xr-x. 1 root root  63496 Nov  2 00:41 /lib/systemd/systemd-timedated
-rwxr-xr-x. 1 root root  22024 Nov  2 00:41 /lib/systemd/systemd-timestamp
-rwxr-xr-x. 1 root root  30364 Nov  2 00:41 /lib/systemd/systemd-uaccess
-rwxr-xr-x. 1 root root  38652 Nov  2 00:41 /lib/systemd/systemd-update-utmp
-rwxr-xr-x. 1 root root  42792 Nov  2 00:41 /lib/systemd/systemd-user-sessions
-rwxr-xr-x. 1 root root  34596 Nov  2 00:41 /lib/systemd/systemd-vconsole-setup

What a *heck* is this?

-- 
vda
