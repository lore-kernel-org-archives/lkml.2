Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752302Ab0DOK4X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 06:56:23 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:35932 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751731Ab0DOK4W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 06:56:22 -0400
Date: Thu, 15 Apr 2010 12:00:48 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Michal Svoboda <michal.svoboda@agents.felk.cvut.cz>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Kconfig: Make config Filter access to /dev/mem default
 y
Message-ID: <20100415120048.488eb44c@lxorguk.ukuu.org.uk>
In-Reply-To: <20100415063626.GG21894@myhost.felk.cvut.cz>
References: <20100413025228.GC10860@localhost.localdomain>
	<m2v7b6bb4a51004142312ze69796ak87d4ee65f6dd5529@mail.gmail.com>
	<20100415063626.GG21894@myhost.felk.cvut.cz>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Apr 2010 08:36:26 +0200
Michal Svoboda <michal.svoboda@agents.felk.cvut.cz> wrote:

> Xiaotian Feng wrote:
> > Have you ever successfully attack by this way? If CONFIG_STRICT_DEVMEM
> > is not set, the /dev/mem access is filtered in pat code.
> 
> If that option doesn't add any protection, what's it good for?


PAT is x86 specific
