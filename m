Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755617Ab1BPOMI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 09:12:08 -0500
Received: from tex.lwn.net ([70.33.254.29]:48663 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753923Ab1BPOMD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 09:12:03 -0500
Date: Wed, 16 Feb 2011 07:12:00 -0700
From: Jonathan Corbet <corbet@lwn.net>
To: Alan Ott <alan@signal11.us>
Cc: Randy Dunlap <rdunlap@xenotime.net>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, jkosina@suse.cz,
        ospite@studenti.unina.it, linux-input@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, bgood@velocity.net
Subject: Re: [PATCH v4 1/2] HID: Documentation for hidraw
Message-ID: <20110216071200.02ccdaa5@bike.lwn.net>
In-Reply-To: <1297829209-10511-2-git-send-email-alan@signal11.us>
References: <1297829209-10511-1-git-send-email-alan@signal11.us>
	<1297829209-10511-2-git-send-email-alan@signal11.us>
Organization: LWN.net
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.24.0; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Feb 2011 23:06:48 -0500
Alan Ott <alan@signal11.us> wrote:

>  Documentation/hid/Makefile      |    8 ++
>  Documentation/hid/hid-example.c |  167 +++++++++++++++++++++++++++++++++++++++

I believe we're trying to get code - especially runnable code - out of the
Documentation tree.  Should this go under samples/ or, if it's useful
enough, under tools/?

Thanks,

jon
