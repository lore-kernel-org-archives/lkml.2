Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932692Ab0LTQGe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 11:06:34 -0500
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:33568 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932657Ab0LTQGd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 11:06:33 -0500
Date: Tue, 21 Dec 2010 01:05:03 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Alexey Charkov <alchark@gmail.com>
Cc: "Janorkar, Mayuresh" <mayur@ti.com>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "vt8500-wm8505-linux-kernel@googlegroups.com" 
	<vt8500-wm8505-linux-kernel@googlegroups.com>
Subject: Re: [PATCH 2/2] fbdev: Modify vsync timing calculation in wm8505fb
Message-ID: <20101220160503.GF26766@linux-sh.org>
References: <20101220130314.GA3627@alchark-u3s> <20101220130957.GB3627@alchark-u3s> <20101220160018.GE26766@linux-sh.org> <AANLkTik9kD3gW1dQ6xe-jpyK9RQxOQJofekaO9Z9FXcC@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTik9kD3gW1dQ6xe-jpyK9RQxOQJofekaO9Z9FXcC@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 20, 2010 at 07:04:53PM +0300, Alexey Charkov wrote:
> 2010/12/20 Paul Mundt <lethal@linux-sh.org>:
> > On Mon, Dec 20, 2010 at 04:09:57PM +0300, Alexey Charkov wrote:
> >> This removes the '+1' in vsync timing calculation for wm8505fb to
> >> directly use values provided from the board setup code.
> >>
> >> Signed-off-by: Alexey Charkov <alchark@gmail.com>
> >
> > This is queued for .37, thanks.
> >
> 
> Paul, in fact, relevant code is only scheduled for merge in .38 (it is
> in linux-next right now). This does not apply to .37.
> 
I noticed that as I went to apply it.. ok, queued for .38 then :-)
