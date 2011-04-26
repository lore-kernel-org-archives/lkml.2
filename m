Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754571Ab1DZLWy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 07:22:54 -0400
Received: from www85.your-server.de ([213.133.104.85]:58861 "EHLO
	www85.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753840Ab1DZLWx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 07:22:53 -0400
From: Olaf Dietsche <olaf+list.linux-kernel@olafdietsche.de>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel@vger.kernel.org, Rod Cordova <rcordova@ethernet.org>
Subject: Re: [PATCH] 2.6.38: access permission filesystem 0.25
References: <Pine.LNX.4.64.1103291321440.32194@fatboy.ethernet.org>
	<87sjtpai9d.fsf@rat.lan> <4DA26159.7050902@oracle.com>
	<87zknw8qh5.fsf@rat.lan> <4DB47564.3020202@oracle.com>
Date: Tue, 26 Apr 2011 13:22:47 +0200
Message-ID: <87oc3tnto8.fsf@rat.lan>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Authenticated-Sender: webmaster@olafdietsche.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap <randy.dunlap@oracle.com> writes:

> On 04/11/11 13:47, Olaf Dietsche wrote:
>
> +config ACCESSFS_USER_PORTS
> +	tristate "User permission based IP ports"
> +	depends on ACCESS_FS && INET
> +	select NET_HOOKS
> +	default n
> +	help
> +	  If you say Y here, you will be able to control access to IP ports
> +	  based on user-/groupid. For this to work, you must say Y
> +	  to CONFIG_NET_HOOKS.
>
> The last sentence of help text is unneeded and could be confusing to a user
> since the "select NET_HOOKS" is already done above.

Yes, I'll change this.

> Have you built this lately?  There have been a few vfs changes recently.
> Building on 2.6.39-rc4, I get this:
[compile errors snipped]

No, I haven't. I've built this against 2.6.38 only, as the subject says.
As soon as the need arises (and laziness allows ;-), I will look into it.

Regards, Olaf
