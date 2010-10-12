Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932621Ab0JLT1F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 15:27:05 -0400
Received: from adelie.canonical.com ([91.189.90.139]:55146 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751497Ab0JLT1B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 15:27:01 -0400
Subject: Re: Proposal for synaptics driver
From: Chase Douglas <chase.douglas@canonical.com>
To: Henrik Rydberg <rydberg@bitmath.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Chris Bagwell <chris@cnpbagwell.com>, Takashi Iwai <tiwai@suse.de>,
        Peter Hutterer <peter.hutterer@who-t.net>,
        linux-input <linux-input@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <4CB4A1BB.9010006@bitmath.org>
References: <1286900585.22715.367.camel@mini> <4CB4A1BB.9010006@bitmath.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 12 Oct 2010 15:26:50 -0400
Message-ID: <1286911610.31864.38.camel@mini>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-10-12 at 19:58 +0200, Henrik Rydberg wrote:
> On 10/12/2010 06:23 PM, Chase Douglas wrote:
> [...]
> 
> > The rest of the
> > touchpad is stationary and does not click. If no one has a better name
> > for these touchpads, I'll refer to them as "integrated buttons"
> > touchpads.
> 
> 
> The name "integrated button" is the term in use for the later Macbook models,
> where there is a button that clicks anywhere on the pad.

Ok, that sounds like the Synaptics ClickPad. An unfortunate name
clash :). How about "embedded buttons" touchpads?

> [...]
> 
> > Now the bit about integrated button touchpad detection. First, I would
> > be interested in learning if anyone can disprove bit 0x200000 of the 0c
> > extended caps flags means integrated buttons.
> 
> 
> I think the easiest way to learn this is to produce a dkms package for people to
> test.

Good idea, I'll make a dkms package when I've got some patches to test.

Thanks,

-- Chase

