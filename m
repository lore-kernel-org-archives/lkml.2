Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754356Ab0DELkh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Apr 2010 07:40:37 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:53288 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751938Ab0DELkb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Apr 2010 07:40:31 -0400
Date: Mon, 5 Apr 2010 12:44:27 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: James Hogan <james@albanarts.com>
Cc: Wim Van Sebroeck <wim@iguana.be>,
       H Hartley Sweeten <hsweeten@visionengravers.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thierry Reding <thierry.reding@avionic-design.de>,
       linux-kernel@vger.kernel.org
Subject: Re: Bad watchdog ioctl definitions
Message-ID: <20100405124427.1daef0d9@lxorguk.ukuu.org.uk>
In-Reply-To: <s2g6a4b170b1004050239ga41e5496r1e416b755f655a0a@mail.gmail.com>
References: <s2g6a4b170b1004050239ga41e5496r1e416b755f655a0a@mail.gmail.com>
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.18.6; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Is it usually even possible to change ioctl numbers for compatibility?
> What's the usual process?

In this case I think its historical and we are stuck with it.
