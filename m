Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757054Ab0EJUq0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 16:46:26 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:43092 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756880Ab0EJUqY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 16:46:24 -0400
MIME-Version: 1.0
In-Reply-To: <20100510162535.GA15137@suse.de>
References: <g2xc2d0b6ec1005041339r9c40822w7a642f9bba976820@mail.gmail.com> 
	<1273011539-13994-1-git-send-email-agust@denx.de> <i2xfa686aa41005091504ve2b35a09m23cd2dc13a331f86@mail.gmail.com> 
	<20100510162535.GA15137@suse.de>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Mon, 10 May 2010 22:46:02 +0200
X-Google-Sender-Auth: t3ns3HshYnxBZMKfsBj49QlTgEY
Message-ID: <AANLkTikQtzUatwiVjZmsMSFRf_MLsffir6N4tNCMSex7@mail.gmail.com>
Subject: Re: [PATCH] serial: mpc52xx_uart: fix null pointer dereference
To: Greg KH <gregkh@suse.de>
Cc: Anatolij Gustschin <agust@denx.de>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, leonardo.lists@gmail.com,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 10, 2010 at 6:25 PM, Greg KH <gregkh@suse.de> wrote:
> On Mon, May 10, 2010 at 12:04:30AM +0200, Grant Likely wrote:
>> Greg, I can either pick this up and push it out to Linus tomorrow, or
>> let you do it.  Whichever you prefer.  Let me know so I don't cause
>> conflicts in your tree.
>
> I have 2 other tty/serial fixes to go to Linus for .34 along with this
> one, so I'll be glad to send it to him.  I've added your ack to the
> patch.

Perfect.  Thanks Greg.

g.
