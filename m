Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755644Ab2CNLZu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 07:25:50 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:34953 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752633Ab2CNLZs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 07:25:48 -0400
Date: Wed, 14 Mar 2012 12:25:43 +0100
From: Johan Hovold <jhovold@gmail.com>
To: Marcel Holtmann <marcel@holtmann.org>,
        "Gustavo F. Padovan" <padovan@profusion.mobi>
Cc: "David S. Miller" <davem@davemloft.net>, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        David Herrmann <dh.herrmann@googlemail.com>,
        Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 0/3] bluetooth: bug fixes for 3.3
Message-ID: <20120314112543.GA5136@localhost>
References: <1331307806-21761-1-git-send-email-jhovold@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1331307806-21761-1-git-send-email-jhovold@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Marcel and Gustavo,

On Fri, Mar 09, 2012 at 04:43:23PM +0100, Johan Hovold wrote:
> This is a revised series which also contains a minimal fix to the memory leak
> discovered by David Hermann upon which the first NULL-pointer-dereference fix
> also depends.
> 
> These patches need to get to Linus ASAP as the problems are present in 3.3-rc6
> as well as earlier kernels and thus should be backported to the stable trees as
> well.

Any chance to get these into 3.3? Otherwise, is it possible to rebase
bluetooth-next on top of these so that Greg can get them into 3.3.1 (and
the other stable trees) once bluetooth-next is merged?

All three bugs can be used to crash any kernel with HCI-UART support and
can probably be used for exploits as they are extremely easy to trigger
reliably.

Thanks,
Johan
