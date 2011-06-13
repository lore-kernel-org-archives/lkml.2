Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752899Ab1FMOZA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 10:25:00 -0400
Received: from casper.infradead.org ([85.118.1.10]:57876 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751404Ab1FMOY7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 10:24:59 -0400
Date: Mon, 13 Jun 2011 07:28:50 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: paulmck@linux.vnet.ibm.com
Cc: Matthew Garrett <mjg59@srcf.ucam.org>,
        Kyungmin Park <kmpark@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ankita Garg <ankita@in.ibm.com>, linux-arm-kernel@lists.infradead.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-pm@lists.linux-foundation.org, svaidy@linux.vnet.ibm.com,
        thomas.abraham@linaro.org
Subject: Re: [PATCH 00/10] mm: Linux VM Infrastructure to support Memory
 Power Management
Message-ID: <20110613072850.7234462b@infradead.org>
In-Reply-To: <20110612230707.GE2212@linux.vnet.ibm.com>
References: <20110610171939.GE2230@linux.vnet.ibm.com>
	<20110610172307.GA27630@srcf.ucam.org>
	<20110610175248.GF2230@linux.vnet.ibm.com>
	<20110610180807.GB28500@srcf.ucam.org>
	<20110610184738.GG2230@linux.vnet.ibm.com>
	<20110610192329.GA30496@srcf.ucam.org>
	<20110610193713.GJ2230@linux.vnet.ibm.com>
	<20110610200233.5ddd5a31@infradead.org>
	<20110611170610.GA2212@linux.vnet.ibm.com>
	<20110611102654.01e5cea9@infradead.org>
	<20110612230707.GE2212@linux.vnet.ibm.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.4; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 12 Jun 2011 16:07:07 -0700
"Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:
> > 
> > the codec issue seems to be solved in time; a previous generation
> > silicon on our (Intel) side had ARM ecosystem blocks that did not do
> > scatter gather, however the current generation ARM ecosystem blocks
> > all seem to have added S/G to them....
> > (in part this is coming from the strong desire to get camera/etc
> > blocks to all use "GPU texture" class memory, so that the camera
> > can directly deposit its information into a gpu texture, and
> > similar for media encode/decode blocks... this avoids copies as
> > well as duplicate memory).
> 
> That is indeed a clever approach!
> 
> Of course, if the GPU textures are in main memory, there will still
> be memory consumption gains to be had as the image size varies (e.g.,
> displaying image on one hand vs. menus and UI on the other). 

graphics drivers and the whole graphics stack is set up to deal with
that... textures aren't per se "screen size", the texture for a button
is only as large as the button (with some rounding up to multiples of
some small power of two) 




-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
