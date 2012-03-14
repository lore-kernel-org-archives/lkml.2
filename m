Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031047Ab2CNSR3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 14:17:29 -0400
Received: from senator.holtmann.net ([87.106.208.187]:55517 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932352Ab2CNSR0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 14:17:26 -0400
Message-ID: <1331749014.14217.112.camel@aeonflux>
Subject: Re: [PATCH 0/3] bluetooth: bug fixes for 3.3
From: Marcel Holtmann <marcel@holtmann.org>
To: Johan Hovold <jhovold@gmail.com>
Cc: "Gustavo F. Padovan" <padovan@profusion.mobi>,
        "David S. Miller" <davem@davemloft.net>,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, David Herrmann <dh.herrmann@googlemail.com>,
        Greg KH <gregkh@linuxfoundation.org>
Date: Wed, 14 Mar 2012 11:16:54 -0700
In-Reply-To: <20120314112543.GA5136@localhost>
References: <1331307806-21761-1-git-send-email-jhovold@gmail.com>
	 <20120314112543.GA5136@localhost>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-1.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Johan,

> > This is a revised series which also contains a minimal fix to the memory leak
> > discovered by David Hermann upon which the first NULL-pointer-dereference fix
> > also depends.
> > 
> > These patches need to get to Linus ASAP as the problems are present in 3.3-rc6
> > as well as earlier kernels and thus should be backported to the stable trees as
> > well.
> 
> Any chance to get these into 3.3? Otherwise, is it possible to rebase
> bluetooth-next on top of these so that Greg can get them into 3.3.1 (and
> the other stable trees) once bluetooth-next is merged?
> 
> All three bugs can be used to crash any kernel with HCI-UART support and
> can probably be used for exploits as they are extremely easy to trigger
> reliably.

only if you have access to the TTY device node in the first place. If
you do not have access to that device node, you can not crash the
kernel.

Can you resend a clean set of patches for bluetooth-next and once we
have that merged, we can talk on how to backport this to 3.3 and also
-stable.

Regards

Marcel


