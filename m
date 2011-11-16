Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757852Ab1KPOBF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 09:01:05 -0500
Received: from cantor2.suse.de ([195.135.220.15]:47302 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755363Ab1KPOBD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 09:01:03 -0500
Date: Wed, 16 Nov 2011 15:01:02 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: =?ISO-8859-15?Q?Denilson_Figueiredo_de_S=E1?= 
	<denilsonsa@gmail.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Christoph Fritz <chf.fritz@googlemail.com>,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: Linux USB HID should ignore values outside Logical Minimum/Maximum
 range
In-Reply-To: <op.v4ceooygdsdv5o@localhost>
Message-ID: <alpine.LNX.2.00.1111161500400.15187@pobox.suse.cz>
References: <op.v3q34la3dsdv5o@localhost> <1319476183.3210.12.camel@lovely> <20111024203204.GA31721@core.coreip.homeip.net> <alpine.LNX.2.00.1110281817380.3541@pobox.suse.cz> <op.v32w1irmdsdv5o@localhost> <alpine.LNX.2.00.1110311349180.3541@pobox.suse.cz>
 <op.v4ceooygdsdv5o@localhost>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Nov 2011, Denilson Figueiredo de Sá wrote:

> > > > +	if (value < field->logical_minimum ||
> > > > +					value > field->logical_maximum) {
> > 
> > After thinking about it a little bit more, I think I agree.
> [...]
> > So please let me know the result of your testing.
> 
> Seems to work on my device, thanks!

Thank you. I have now queued the patch with your Tested-by.

-- 
Jiri Kosina
SUSE Labs
