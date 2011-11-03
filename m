Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756421Ab1KCRcs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 13:32:48 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:50660 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756402Ab1KCRcr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 13:32:47 -0400
MIME-Version: 1.0
In-Reply-To: <20111103162238.27609.11515.stgit@rabbit.intern.cm-ag>
References: <20111103162238.27609.11515.stgit@rabbit.intern.cm-ag>
Date: Thu, 3 Nov 2011 18:31:23 +0100
Message-ID: <CAFLxGvzRG_zgG_4ym9CkTOr3kNzNb6zb553kgdy3jCeJSxAP9Q@mail.gmail.com>
Subject: Re: [PATCH] new cgroup controller "fork"
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: Max Kellermann <mk@cm4all.com>
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
        max@duempel.org, menage@google.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 3, 2011 at 5:22 PM, Max Kellermann <mk@cm4all.com> wrote:
> +struct cgroup_fork {
> +       struct cgroup_subsys_state css;
> +
> +       /** protect the "remaining" attribute */
> +       spinlock_t lock;
> +
> +       /**
> +        * The remaining number of forks allowed.  -1 is the magic
> +        * value for "unlimited".
> +        */
> +       int remaining;
> +};

Wouldn't an atomic_t also do it?

-- 
Thanks,
//richard
