Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759538Ab2JLPIA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 11:08:00 -0400
Received: from smtprelay-b12.telenor.se ([62.127.194.21]:45051 "EHLO
	smtprelay-b12.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754867Ab2JLPH7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 11:07:59 -0400
X-SENDER-IP: [85.230.29.114]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AkaKALkxeFBV5h1yPGdsb2JhbABEhSkjhQC0CwSBAxkBAQEBHxkNJ4IhAQU6HCMQCANGFCUKGgqIEbpbFItxA4UnYAOVbIVyjS4
X-IronPort-AV: E=Sophos;i="4.80,577,1344204000"; 
   d="scan'208";a="209196554"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Fri, 12 Oct 2012 17:10:38 +0200
To: Hans de Goede <hdegoede@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Stuge <peter@stuge.se>
Subject: Re: REGRESSION: usbdevfs:
 Use-scatter-gather-lists-for-large-bulk-transfers
Message-ID: <20121012151038.GA3103@polaris.bitmath.org>
References: <20121010203118.GA792@polaris.bitmath.org>
 <5076819C.9010504@redhat.com>
 <20121011213707.GA2187@polaris.bitmath.org>
 <20121011215310.GA24651@kroah.com>
 <50782517.1020408@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50782517.1020408@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >>Or, the large bulk transfer actually never worked in the first place.
> 
> Large input transfers certainly do, as they were part of my tests, but
> I must admit my test cases seem to not include large output transfers
> (my bad).

Oh right, I should change the wording to reflect that this is for
output only. Please see the reply to Alan's comment for a (possibly)
better version.

Thanks,
Henrik
