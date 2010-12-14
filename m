Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757975Ab0LNEgu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 23:36:50 -0500
Received: from leo.clearchain.com ([199.73.29.74]:16848 "EHLO
	mail.clearchain.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757345Ab0LNEgt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 23:36:49 -0500
Date: Tue, 14 Dec 2010 14:36:36 +1000
From: Peter Hutterer <peter.hutterer@who-t.net>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Chase Douglas <chase.douglas@canonical.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] input: mt: Interface and MT_TOOL documentation updates
Message-ID: <20101214043635.GB12059@salty.local>
References: <1292001842-5000-1-git-send-email-rydberg@euromail.se>
 <4D065BDE.5020107@canonical.com>
 <4D068E3C.8080100@euromail.se>
 <4D06A60D.7010409@canonical.com>
 <4D06AB66.8090909@euromail.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D06AB66.8090909@euromail.se>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Greylist: Sender is SPF-compliant, not delayed by milter-greylist-4.0.1 (mail.clearchain.com [127.0.0.1]); Tue, 14 Dec 2010 15:06:40 +1030 (CST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 14, 2010 at 12:25:26AM +0100, Henrik Rydberg wrote:
> >> The envelope contacts serve as a way to detect a small area of fingers or a
> 
> >> large area of fingers. There is nothing inherently problematic with having one
> >> or three or more such contacts.
> > 
> > Then I'm more confused :).
> > 
> > I see one problem: devices that report two touch points, (X1, Y1) and
> > (X2, Y2), but in reality the touches could be at (X1, Y2) and (X2, Y1)
> > instead. Using a rectangle helps resolve this issue for panning and
> > pinching, though not for rotation.
> 
> 
> If panning and pinching and rotation could all be recovered properly, then the
> individual contacts could actually have been reconstructed properly in the first
> place. This is the whole point - there is not enough information available for
> rotation to be recovered properly.

can you post an example event stream of the MT_ENVELOPE tool? I'm having
trouble wrapping my head around it.
 
Cheers,
  Peter
