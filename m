Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755409Ab2KMR1e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 12:27:34 -0500
Received: from smtprelay-b31.telenor.se ([213.150.131.20]:49619 "EHLO
	smtprelay-b31.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753488Ab2KMR1c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 12:27:32 -0500
X-SENDER-IP: [85.230.29.114]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aj6xAFSColBV5h1yPGdsb2JhbABEhTEjhQC4JgIBfhkBAQEBHxkNJ4IeAQEEATocIwULCAMOOBQlChoxh2YKqhWQLRSND4F+gnxhA5V7hXuNOQ
X-IronPort-AV: E=Sophos;i="4.80,768,1344204000"; 
   d="scan'208";a="228996454"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Tue, 13 Nov 2012 18:33:53 +0100
To: Jiri Kosina <jkosina@suse.cz>
Cc: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 00/13] Win 8 support for digitizers
Message-ID: <20121113173353.GA878@polaris.bitmath.org>
References: <1352306256-12180-1-git-send-email-benjamin.tissoires@gmail.com>
 <alpine.LNX.2.00.1211130845270.15877@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1211130845270.15877@pobox.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Benjamin,

> > here is the third version of this patchset.
> > I think I included most of Henrik's comments.
> > 
> > Happy reviewing :)

thanks for the changes :-)

Jiri,

> I am fine with the HID-specific changes (and I have sent out my Acks to 
> the invidivual patches).

Looks reasonable to me too (although I have not looked through the exponent
code enough to want to formally ack it).

> For hid-multitouch changes, I'd like to have Reviewed-by: from Henrik as 
> well. Henrik, are you planning to review this patchset, please?

Yes, and finally done.

Cheers,
Henrik
