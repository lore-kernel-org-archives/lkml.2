Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752875Ab2EIF3w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 01:29:52 -0400
Received: from smtprelay-b11.telenor.se ([62.127.194.20]:52315 "EHLO
	smtprelay-b11.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751718Ab2EIF3u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 01:29:50 -0400
X-SENDER-IP: [85.230.168.62]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtSfAPj/qU9V5qg+PGdsb2JhbABEijWneAMBgR0ZAQEBATc0gg0BBTocIxAIA0YUJQoaiCW7JROLM4FrgwFjBJV9hgaNKA
X-IronPort-AV: E=Sophos;i="4.75,556,1330902000"; 
   d="scan'208";a="331410928"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Wed, 9 May 2012 07:35:02 +0200
To: Peter Hutterer <peter.hutterer@who-t.net>
Cc: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, chatty@enac.fr, chasedouglas@gmail.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] Input: MT - Include win8 support
Message-ID: <20120509053502.GA30063@polaris.bitmath.org>
References: <1336230499-1450-1-git-send-email-rydberg@euromail.se>
 <CAN+gG=HqGmf77P6=7RMFT_Ez7Ysp4ZVJ6skfAoDcZ7JN1JtYnw@mail.gmail.com>
 <20120506182835.GA12221@polaris.bitmath.org>
 <20120508060221.GA15925@yabbi.bne.redhat.com>
 <20120508184052.GA23748@polaris.bitmath.org>
 <20120508235219.GA4067@yabbi.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120508235219.GA4067@yabbi.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > > Looking at the figure, it is clear that the MT model has two centers,
> > > > one for each ellipse. Thus, center is not discriminating
> > > > enough. Perhaps ABS_MT_OUTER_X/Y is more appropriate, then?
> > > 
> > > ABS_MT_OUTER_CENTER
> > 
> > I appreciate the suggestion, but along two-word combinations,
> > ABS_MT_OUTER_POSITION would integrate better with existing names. Both
> > seem awfully long, though.
> 
> problem I see with "outer position" is that I'd associate it with the
> top/left position of whatever "outer" is, not with the center of said
> envelope. that's why I'd argue that "center" should be somewhere in the
> name.

Top-left does not apply to an ellipse, so that argument makes little
sense for someone looking only at the MT protocol. Given that position
is the actual protocol name for the center of the touching ellipse,
there is hardly any doubt what it means in this context.

How about ABS_MT_TOOL_X/Y?

Henrik
