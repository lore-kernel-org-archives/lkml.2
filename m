Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757017Ab2AKILM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 03:11:12 -0500
Received: from smtp.snhosting.dk ([87.238.248.203]:24193 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755326Ab2AKILK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 03:11:10 -0500
Date: Wed, 11 Jan 2012 09:11:04 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: James Morris <jmorris@namei.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dmitry Kasatkin <dmitry.kasatkin@intel.com>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>
Subject: Re: [GIT] Security subsystem updates for 3.3
Message-ID: <20120111081104.GA26007@merkur.ravnborg.org>
References: <alpine.LRH.2.00.1201091252220.18816@tundra.namei.org> <CA+55aFwD2-bhd32L1SsjPQrpwOBhBdxTUaOj=oXN24vPwc+Wsg@mail.gmail.com> <alpine.LRH.2.00.1201111834570.2966@tundra.namei.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.00.1201111834570.2966@tundra.namei.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > 
> > And "DIGSIG" is really a horrible config name. Did somebody run out of
> > letters suddenly? Is there some global letter shortage that I haven't
> > been told of and that we should do something about?
> 
> Any objections to DIGITAL_SIGNATURE_API ?
Naming is always fun..

In general when applicable it is nice when config options are prefixed
whith something that indicate their relation ship.
But many config symbols fails to do so today - so no strong feeling.

	Sam
