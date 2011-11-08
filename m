Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932778Ab1KHOzY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 09:55:24 -0500
Received: from dsl-67-204-24-19.acanac.net ([67.204.24.19]:34463 "EHLO
	mail.ellipticsemi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755138Ab1KHOzR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 09:55:17 -0500
Date: Tue, 8 Nov 2011 09:55:10 -0500
From: Nick Bowler <nbowler@elliptictech.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 3.2-rc1
Message-ID: <20111108145510.GA5142@elliptictech.com>
References: <CA+55aFzytqbGcOzWvYAo-EnJCeK5mFqdCF5OjMTeM5UBfeyCXw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzytqbGcOzWvYAo-EnJCeK5mFqdCF5OjMTeM5UBfeyCXw@mail.gmail.com>
Organization: Elliptic Technologies Inc.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-11-07 18:10 -0800, Linus Torvalds wrote:
> Have fun, give it a good testing. There shouldn't be anything hugely
> scary in there, but there *is* a lot of stuff. The fact that 3.1
> dragged out did mean that this ended up being one of the bigger merge
> windows, but I'm not feeling *too* nervous about it.

Mode switches are very noisy on an Intel G45 in 3.2-rc1:

  HDMI hot plug event: Codec=3 Pin=3 Presence_Detect=1 ELD_Valid=1
  HDMI status: Codec=3 Pin=3 Presence_Detect=1 ELD_Valid=1
  HDMI: detected monitor W2253 at connection type HDMI
  HDMI: available speakers: FL/FR
  HDMI: supports coding type LPCM: channels = 2, rates = 32000 44100 48000, bits = 16 20 24

These lines get printed every single switch; previously only a single
line was printed once at boot (the "HDMI status" line).

Cheers,
-- 
Nick Bowler, Elliptic Technologies (http://www.elliptictech.com/)
