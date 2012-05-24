Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751772Ab2EXEpI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 00:45:08 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:58988 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751285Ab2EXEpG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 00:45:06 -0400
Date: Wed, 23 May 2012 21:44:56 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: david kennedy <david.kennedy@telenet.be>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Bug: USB Stalled endpoint.
Message-ID: <20120524044456.GA14325@kroah.com>
References: <4FBBA946.2080900@telenet.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FBBA946.2080900@telenet.be>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 22, 2012 at 04:57:10PM +0200, david kennedy wrote:
> Bug report.
> 
> Bug Summary:
> On attachment of a camera device via a high speed USB port, device
> recognized but fails to complete connection feedback, perhaps due to
> reported 'Stalled endpoint".
> 
> System: SuSE 11.4
> Kernel: 2.6.37.6-0.11-desktop

As you are running a distro kernel, and an old one at that, please file
a bug on the opensuse bugzilla, there's nothing we can do here about
that unsupported kernel at all here, sorry.

greg k-h
