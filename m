Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932245Ab2JUP2b (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2012 11:28:31 -0400
Received: from netrider.rowland.org ([192.131.102.5]:46238 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932129Ab2JUP2a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2012 11:28:30 -0400
Date: Sun, 21 Oct 2012 11:28:29 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Daniel Mack <zonque@gmail.com>
cc: "Artem S. Tashkinov" <t.artem@lycos.com>, <bp@alien8.de>, <pavel@ucw.cz>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <security@kernel.org>, <linux-media@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <alsa-devel@alsa-project.org>
Subject: Re: was: Re: A reliable kernel panic (3.6.2) and system crash when
 visiting a particular website
In-Reply-To: <5084132B.8080609@gmail.com>
Message-ID: <Pine.LNX.4.44L0.1210211126570.14867-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 21 Oct 2012, Daniel Mack wrote:

> As the usb list is still in Cc: - Artem's lcpci dump shows that his
> machine features XHCI controllers. Can anyone think of a relation to
> this problem?
> 
> And Artem, is there any way you boot your system on an older machine
> that only has EHCI ports? Thinking about it, I wonder whether the freeze
> in VBox and the crashes on native hardware have the same root cause. In
> that case, would it be possible to share that VBox image?

Don't grasp at straws.  All of the kernel logs Artem has posted show 
ehci-hcd; none of them show xhci-hcd.  Therefore the xHCI controller is 
highly unlikely to be involved.

Alan Stern

