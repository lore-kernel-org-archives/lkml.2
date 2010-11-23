Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932653Ab0KWAwe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 19:52:34 -0500
Received: from tex.lwn.net ([70.33.254.29]:33111 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932424Ab0KWAwd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 19:52:33 -0500
Date: Mon, 22 Nov 2010 17:52:30 -0700
From: Jonathan Corbet <corbet@lwn.net>
To: <mahatma@eu.by>
Cc: root@eu.by, <linux-kernel@vger.kernel.org>,
        "Dan Carpenter" <error27@gmail.com>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Subject: Re: [PATCH v3+]viafb: I2C/DDC LCD detection for VIA framebuffer
Message-ID: <20101122175230.7ac61c54@bike.lwn.net>
In-Reply-To: <20101122160259.57EE1AF9@resin17.mta.everyone.net>
References: <20101122160259.57EE1AF9@resin17.mta.everyone.net>
Organization: LWN.net
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.23.2; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Nov 2010 16:02:59 -0800
"Denis Kaganovich" <root@eu.by> wrote:

> PS Sorry for lamering. Bad webmail, home & bugfix...

You've not acknowledged any of my comments from the last time around?
And you're still not Ccing the people involved with this code?
Everything I said in response to the previous posting still applies...

Additional comment: when you post a revised version of a patch, it's
nice to say what has changed.

Might I suggest a look at:

	Documentation/SubmittingPatches
	Documentation/development-process

for a lot of useful information?

jon
