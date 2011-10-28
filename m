Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752682Ab1J1TT2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 15:19:28 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:53741 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750904Ab1J1TT0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 15:19:26 -0400
Subject: Re: Linux USB HID should ignore values outside Logical
 Minimum/Maximum range
From: Christoph Fritz <chf.fritz@googlemail.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Denilson Figueiredo de =?ISO-8859-1?Q?S=E1?= 
	<denilsonsa@gmail.com>,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        linux-usb@vger.kernel.org
In-Reply-To: <alpine.LNX.2.00.1110281817380.3541@pobox.suse.cz>
References: <op.v3q34la3dsdv5o@localhost> <1319476183.3210.12.camel@lovely>
	 <20111024203204.GA31721@core.coreip.homeip.net>
	 <alpine.LNX.2.00.1110281817380.3541@pobox.suse.cz>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 28 Oct 2011 21:27:00 +0200
Message-ID: <1319830020.3467.7.camel@lovely>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-10-28 at 18:23 +0200, Jiri Kosina wrote:
> On Mon, 24 Oct 2011, Dmitry Torokhov wrote:
> 
> > While input core does not clam or validate the values reported by the 
> > driver it might make sense to do so in hid-input; I am not sure how 
> > often these limits programmed intorrectly. Jiri i sprobably the best 
> > person to answer this question.
> 
> I haven't met such a device myself yet.
> 
> On the other hand I feel like just dropping the report on the floor should 
> be the proper thing to do.
> 
> 
> Christoph, how about the (untested at my side yet) patch below? It'd be 
> nice if you could test with the device you are seeing the problem with and 
> let me know.


I don't have this device and I'm not the person who started this thread.
It's Denilson Figueiredo de Sá <denilsonsa@gmail.com> , just see above.

Denilson, please comment.

Thanks,
 -- Christoph


