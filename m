Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755848Ab1FNJZA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 05:25:00 -0400
Received: from smtp.tele.fi ([192.89.123.25]:54581 "EHLO smtp.tele.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755428Ab1FNJY5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 05:24:57 -0400
X-Originating-Ip: [194.89.68.22]
Date: Tue, 14 Jun 2011 12:24:55 +0300
From: Pasi =?iso-8859-1?Q?K=E4rkk=E4inen?= <pasik@iki.fi>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Lukasz <el.es.cr@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [OT] Re: [PATCH 00/15] GMA500 KMS and GEM
Message-ID: <20110614092455.GP32595@reaktio.net>
References: <20110608100411.9478.86672.stgit@localhost.localdomain> <loom.20110608T130453-800@post.gmane.org> <20110608132449.4a50b548@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110608132449.4a50b548@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 08, 2011 at 01:24:49PM +0100, Alan Cox wrote:
> > But I see the vblank (the feature that lets the (whatever space) programs 
> > know when the vertical return occurs ?) as a quite useful thing...
> 
> Nothing much in the 2D world seems to use it for anything. In the 3D
> world yes vblank syncing and page flipping is important, but the driver
> is 2D only.
> 

Video players probably want to use it to provide tear/stutter-free playback? 

-- Pasi

