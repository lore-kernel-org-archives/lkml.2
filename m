Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757050Ab0ENQhM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 12:37:12 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:37287 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752240Ab0ENQhH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 12:37:07 -0400
Date: Fri, 14 May 2010 17:43:48 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Soren Hansen <soren@linux2go.dk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] Allow hvc tty's to pose as vt's
Message-ID: <20100514174348.74b74821@lxorguk.ukuu.org.uk>
In-Reply-To: <0dd0991d71cac0a746891863264941c100bbc67a.1273825543.git.soren@linux2go.dk>
References: <cover.1273825543.git.soren@linux2go.dk>
	<0dd0991d71cac0a746891863264941c100bbc67a.1273825543.git.soren@linux2go.dk>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 May 2010 18:10:12 +0200
Soren Hansen <soren@linux2go.dk> wrote:

> Allow for hvc based tty's to take over the vt driver's major number
> and namespace.

We've got a perfect good udev and symlink functionality to
rename devices in userspace.

NAK.

I can see why its useful as a hack in a specific user environment but its
not appropriate for upstream.

