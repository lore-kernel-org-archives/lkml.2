Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755808Ab1F1AJB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 20:09:01 -0400
Received: from lucidpixels.com ([72.73.18.11]:45709 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755565Ab1F1AIx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 20:08:53 -0400
Date: Mon, 27 Jun 2011 20:08:52 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: "Ronciak, John" <john.ronciak@intel.com>
cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "e1000-devel@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>
Subject: RE: [E1000-devel] 2.6.39.2: skb_over_panic: kernel BUG at
 net/core/skbuff.c:127!
In-Reply-To: <alpine.DEB.2.02.1106271831060.6721@p34.internal.lan>
Message-ID: <alpine.DEB.2.02.1106272006310.6864@p34.internal.lan>
References: <alpine.DEB.2.02.1106271742310.6721@p34.internal.lan> <D38E8E86660E514AB505863C19C9287C03A525@ORSMSX101.amr.corp.intel.com> <alpine.DEB.2.02.1106271814200.6721@p34.internal.lan> <D38E8E86660E514AB505863C19C9287C03A585@ORSMSX101.amr.corp.intel.com>
 <alpine.DEB.2.02.1106271831060.6721@p34.internal.lan>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 27 Jun 2011, Justin Piszcz wrote:

>
>
> On Mon, 27 Jun 2011, Ronciak, John wrote:
>

Hi,

Here's another crash: (see the dmesg, its right when powering the disks up)
http://home.comcast.net/~jpiszcz/20110627/IMG_2704.JPG

In this case, I was mkfs.xfs -f (some disks attached to a sata dock) over
an Sil 3132 card, I disconnected the card and re-ran it w/ the on-board
SATA controller and the problem no longer occurred (crashed repeatedly
everytime with the NIC error), strange.

In any case, will let you know if there are any further crashes after
removing that PCI-e card.

Justin.

