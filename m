Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754061Ab1EHVe1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 May 2011 17:34:27 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:53936 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752333Ab1EHVeZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 May 2011 17:34:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=wSZHmrL6qrupsmgtYh+6TzdBatvtmo3wM5VQkDiF5zdAIT1wG1xiwELuBkXg8hRQq9
         uycwgYDr0/iWfSl+h91nOP6NEaBSwXX+8j8N8o+Yx5zd8mNUPB8JGI6GLuFqtTbtB//W
         UOj6/X2OnRfrpedTcvJjfTx3vkvyby72aBUdU=
Date: Sun, 8 May 2011 23:26:15 +0200
From: Christoph Fritz <chf.fritz@googlemail.com>
To: "Adi J. Sieker" <adi@core.adi.io>
Cc: Jiri Kosina <jkosina@suse.cz>, Alan Stern <stern@rowland.harvard.edu>,
        Oliver Neukum <oliver@neukum.org>,
        USB list <linux-usb@vger.kernel.org>, linux-input@vger.kernel.org,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: USB keyboard recognized as HID keyboard but doesn't work
Message-ID: <20110508212615.GA4193@lovely.krouter>
References: <Pine.LNX.4.44L0.1105030945410.2085-100000@iolanthe.rowland.org>
 <alpine.LNX.2.00.1105061456320.28291@pobox.suse.cz>
 <4DC3FEC7.6050503@sieker.io>
 <1304807093.5891.45.camel@mars>
 <4DC6F44E.1000703@sieker.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DC6F44E.1000703@sieker.io>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 08, 2011 at 09:51:42PM +0200, Adi J. Sieker wrote:
> On 08/05/11 00:24, Christoph Fritz wrote:
> >
> >  I'm not sure about my patch below because of interface one, maybe you
> >can give it a try.
> >
> What kernel version do I need? I'm running Ubuntu 10.04, so can I
> apply this to a 2.6.32 Ubuntu kernel or do I need a current 2.6.39?

A current kernel is recommended.


bye,
 -- chf
