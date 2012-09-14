Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759959Ab2INTSe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 15:18:34 -0400
Received: from smtprelay-b22.telenor.se ([195.54.99.213]:49677 "EHLO
	smtprelay-b22.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751529Ab2INTSc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 15:18:32 -0400
X-SENDER-IP: [85.230.29.114]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApdLAM2BU1BV5h1yPGdsb2JhbABFhR4jhQCxSBkBAQEBNzSCIAEBBAE6HCMQCANGFCUKGogaCrttFJETYAOVYIVwjRo
X-IronPort-AV: E=Sophos;i="4.80,424,1344204000"; 
   d="scan'208";a="188889553"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Fri, 14 Sep 2012 21:25:54 +0200
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 16/20] HID: Only dump input if someone is listening
Message-ID: <20120914192554.GA6498@polaris.bitmath.org>
References: <1346528835-363-1-git-send-email-rydberg@euromail.se>
 <20120910190226.GA877@polaris.bitmath.org>
 <alpine.LNX.2.00.1209102248250.22683@pobox.suse.cz>
 <5556929.93aC5q4087@dtor-d630.eng.vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5556929.93aC5q4087@dtor-d630.eng.vmware.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > I went ahead and pushed the (updated) branch to my for-next, to get
> > > some integration coverage. It is that time. Jiri, I added your
> > > Acked-by on the hid patches for now, hope that is alright.
> > 
> > Yes, it is, thanks Henrik.
> > 
> > Dmitry, I can pull the whole lot into my tree once you Ack/Signoff the
> > input patches, if you wish.
> 
> Yes, let me try to go through the patches tonight and I'll let yo know...

Dmitry, given the oops-fix amended, are you ok with the input core
changes at this point? If so, I can add your ACK on those, and refresh
the input, input-mt and hid changes to next. I will be back with the
reworked bcm5974 set, but the rest should be ready for a pull from
Jiri.

Thanks,
Henrik
