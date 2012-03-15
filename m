Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030768Ab2COPB3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 11:01:29 -0400
Received: from plane.gmane.org ([80.91.229.3]:54699 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030378Ab2COPBZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 11:01:25 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: el es <el.es.cr@gmail.com>
Subject: Re: [V3 PATCH 1/2] drivers-gpu-drm-allow-to-load-edid-firmware.patch
Date: Thu, 15 Mar 2012 15:01:13 +0000 (UTC)
Message-ID: <loom.20120315T155137-914@post.gmane.org>
References: <20120315095219.520461363@osadl.org>	<20120315095357.087317967@osadl.org> <CAE2SPAaz4oa7q4UTZ=iiKGv3v8=6xT_=odgMN-mrH9enRP26qQ@mail.gmail.com> <4F61C843.8050307@osadl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: sea.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 81.139.145.92 (Mozilla/5.0 (Windows NT 5.1; rv:10.0.2) Gecko/20100101 Firefox/10.0.2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Carsten Emde <C.Emde <at> osadl.org> writes:

> > Windows allow vendor to override eddid based on 3 bytes manufacturer
> > and product code.
> This may solve the situation when a particular monitor lies about the
> required setting or its EDID data set has an invalid CRC. However, this
> does not solve the situation when we do not get any useful EDID
> information, because something is totally broken. This also applies to
> the KVM situation when the KVM sends EDID data that are totally
> unrelated to the monitor at the other side of the KVM.
> 
> > Seems a reasonnable approach to follow.
> I am not yet convinced.
> 

I second that, I have/had a laptop (with Radeon thou) that I had to 
override the EDID it read from its own panel, which had most info 
good but CRC wrong...

This manifested itself as the system thinking all it had was 1024x768 on
a 1280x800 panel - not scaling and remaining space filled with garbage.
Even its own bios did not recognize that (!), never mind Windows.

Before this patch (and probably some base EDID data...?) I'd have to set 
mode override in X itself (and I had it working so beautifully)

(laptop's unfortunately not in use any more 'cause of panel hinge 
damage and post-children keyboard fail and generally 'morally' 
done&dusted (AMD Mob Sempron 1.8GHz+Mob Radeon X700) but may 
still boot...)

> 	-Carsten.
> 
L.

