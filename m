Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755290Ab1EGN7g (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 May 2011 09:59:36 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:65473 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754958Ab1EGN7d convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 May 2011 09:59:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=ts6GkeOw4crptWyFE+vWwjib4+ihxZzkPG8AmEWtYom9daV4lCzAlNsaNS+PodO3M4
         UcjTc8bRcybp/QQLZJlEs7ZiUJFJaIUtpjW9crBgDYPuWkHbSxiDoaQEJ3G+rPeIpquY
         0BNnFU1Gft4hnfRJ1WsJhIHcuW5a0zvR9nLAg=
MIME-Version: 1.0
In-Reply-To: <1304735101-1824-7-git-send-email-ebiederm@xmission.com>
References: <m1tyd7p7tq.fsf@fess.ebiederm.org> <1304735101-1824-1-git-send-email-ebiederm@xmission.com>
 <1304735101-1824-7-git-send-email-ebiederm@xmission.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Sat, 7 May 2011 09:59:12 -0400
Message-ID: <BANLkTikmvyBZn7iOiSpX3vf7v11nP7N19g@mail.gmail.com>
Subject: Re: [PATCH 7/7] ns: Wire up the setns system call
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        jamal <hadi@cyberus.ca>, Daniel Lezcano <daniel.lezcano@free.fr>,
        Linux Containers <containers@lists.osdl.org>,
        Renato Westphal <renatowestphal@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 6, 2011 at 22:25, Eric W. Biederman wrote:
> v2: Most of the architecture support added by Daniel Lezcano <dlezcano@fr.ibm.com>
> v3: ported to v2.6.36-rc4 by: Eric W. Biederman <ebiederm@xmission.com>
> v4: Moved wiring up of the system call to another patch
> v5: ported to v2.6.39-rc6
>
>  arch/blackfin/include/asm/unistd.h     |    3 ++-
>  arch/blackfin/mach-common/entry.S      |    1 +

Acked-by: Mike Frysinger <vapier@gentoo.org>
-mike
