Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757875Ab2GMOoL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 10:44:11 -0400
Received: from fias.uni-frankfurt.de ([141.2.248.1]:58650 "EHLO
	fias.uni-frankfurt.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753807Ab2GMOoJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 10:44:09 -0400
Message-ID: <1342190647.6607.37.camel@blech>
Subject: Re: UIO: missing resource mapping
From: Dominic Eschweiler <eschweiler@fias.uni-frankfurt.de>
To: "Hans J. Koch" <hjk@hansjkoch.de>
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
        Andreas Schallenberg <embedded@gmx.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, kvm@vger.kernel.org
Date: Fri, 13 Jul 2012 16:44:07 +0200
In-Reply-To: <20120713141816.GB2554@local>
References: <4FFE7C1F.7080702@gmx.net> <20120712194432.GA2592@local>
	 <20120712231632.GC9317@redhat.com> <1342166955.6607.5.camel@blech>
	 <20120713132223.GA10959@redhat.com> <20120713141816.GB2554@local>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 8BIT
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, den 13.07.2012, 16:18 +0200 schrieb Hans J. Koch:
> If somebody maps the card's memory through the UIO driver and somebody
> else also maps it using sysfs, that is possible. What happens if both
> write to the same hardware registers is a different topic. Writing a
> driver implies some responsibility, even if it's done in userspace. 

That's true and I would not complain. I'm just saying that there is the
possibility to disturb a kernel driver by mapping memory etc. I think it
is worth to considerate moving the BAR mapping code to UIO. Especially,
when I look at the discussions about what effects mappable DMA memory
can have on the system security. 

-- 
Gruß
  Dominic

