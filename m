Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754018Ab2HUT0N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 15:26:13 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:53858 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752456Ab2HUT0I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 15:26:08 -0400
X-Authenticated: #28250155
X-Provags-ID: V01U2FsdGVkX19j2N1lG+hjOFq5nZlXyYL0BGDQmeRlMEyXeWjmcz
	OPP8cBdfo1cCgj
From: Sven Joachim <svenjoac@gmx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        maximlevitsky@gmail.com, bskeggs@redhat.com
Subject: Re: [ 00/46] 3.5.3-stable review
References: <20120820035832.274275502@linuxfoundation.org>
Date: Tue, 21 Aug 2012 21:26:00 +0200
In-Reply-To: <20120820035832.274275502@linuxfoundation.org> (Greg
	Kroah-Hartman's message of "Sun, 19 Aug 2012 20:58:36 -0700")
Message-ID: <87ipccgi7r.fsf@turtle.gmx.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I would like to see commit 2064db725cc6d4ea19a24c138bc37939b63e3ae6
(drm/nv86/fifo: suspend fix) cherry-picked to the 3.5 kernel series, it
makes suspend work again on my machine.  Could you please queue this up
for 3.5.4?

Apologies for thread hijacking, my attempts to directly send the request
to stable@vger.kernel.org failed (mail seems to have disappeared in the
bit bucket). :-(

Cheers,
       Sven
