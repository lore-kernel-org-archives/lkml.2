Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751969Ab1GYNdK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 09:33:10 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:48062 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751356Ab1GYNdI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 09:33:08 -0400
From: Peter Korsgaard <jacmet@sunsite.dk>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Luke Kenneth Casson Leighton <lkcl@lkcl.net>, debian-arm@lists.debian.org,
        linux-kernel@vger.kernel.org, Wookey <wookey@wookware.org>
Subject: Re: dynamic LCD support for "embedded" systems
References: <CAPweEDwVhaHr=5i8giGCkDWxK9G8Vvibq59vhbu6RsnZf9uerA@mail.gmail.com>
	<20110725131701.112e635e@lxorguk.ukuu.org.uk>
	<CAPweEDzQXUTtAwiU4qEB_eQqNgJeazpeTxixyAnbgscvC5yujQ@mail.gmail.com>
	<20110725140610.47fdda27@lxorguk.ukuu.org.uk>
Date: Mon, 25 Jul 2011 15:32:57 +0200
In-Reply-To: <20110725140610.47fdda27@lxorguk.ukuu.org.uk> (Alan Cox's message
	of "Mon, 25 Jul 2011 14:06:10 +0100")
Message-ID: <87y5zmqyd2.fsf@macbook.be.48ers.dk>
User-Agent: Gnus/5.110009 (No Gnus v0.9) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Alan" == Alan Cox <alan@lxorguk.ukuu.org.uk> writes:

 >> DVI monitor), and that EDID data just gets passed-through via the VGA
 >> IC. so it's all the same stuff... so what's the damn difference
 >> between a system with a VGA monitor and a system with the exact same
 >> LCD panel *from* that VGA monitor, ehn? :)  ok, rhetorical question.

 Alan> I'm not convinced it is the same stuff for various reaosns and bits of
 Alan> historical bug fixing and observation.

Indeed. Often, raw LVDS panels just have power, LVDS and (potentially)
backlight signals - No EDID. eDP panels might be different though, and
some newer LVDS panels do have a DDC channel with EDID.

-- 
Bye, Peter Korsgaard
