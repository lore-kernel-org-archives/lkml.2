Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758898Ab2J2SAZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 14:00:25 -0400
Received: from jacques.telenet-ops.be ([195.130.132.50]:40630 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756100Ab2J2SAX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 14:00:23 -0400
Message-ID: <1351533619.4415.1.camel@piranha.localdomain>
Subject: Re: 3.7-rc2: corrupted image on Radeon HD 7800 after restarting X
From: Frederik Himpe <fhimpe@telenet.be>
To: Michel =?ISO-8859-1?Q?D=E4nzer?= <michel@daenzer.net>
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Date: Mon, 29 Oct 2012 19:00:19 +0100
In-Reply-To: <1351507249.11783.4.camel@thor.local>
References: <k6engr$knj$1@ger.gmane.org>
	 <1351507249.11783.4.camel@thor.local>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.1-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-10-29 at 11:40 +0100, Michel Dänzer wrote:
> On Fre, 2012-10-26 at 19:15 +0000, Frederik Himpe wrote: 
> > When I restart my display manager (GDM) from tty0, I get a corrupted 
> > image where parts of the X display before I restarted GDM become visible 
> > on both the newly started X server instance as on tty0. When moving the 
> > mouse in X, the current (correct) image around the cursor is replaced by 
> > the image which was shown before X was started.
> > 
> > 01:00.0 VGA compatible controller [0300]: Advanced Micro Devices [AMD] 
> > nee ATI PITCAIRN PRO [Radeon HD 7800 Series] [1002:6819] (prog-if 00 [VGA 

> > 
> > dmesg, .config, lspci and a picture showing a tty0 with parts of the 
> > image corrupted by the image of the GDM screen before it was restarted, 
> > can be found at http://artipc10.vub.ac.be/~frederik/linux-3.7-rc2/
> 
> Please also provide the Xorg.0.log file from after you restarted gdm.

I have uploaded Xorg.0.log to
https://artipc10.vub.ac.be/~frederik/linux-3.7-rc2/Xorg.0.log

-- 
Frederik Himpe <fhimpe@telenet.be>

