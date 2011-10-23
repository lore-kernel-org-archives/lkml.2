Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755183Ab1JWIbi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Oct 2011 04:31:38 -0400
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:41567 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751291Ab1JWIbg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Oct 2011 04:31:36 -0400
X-Sasl-enc: Svkm9tVu3iTBbw1ohO5QUYFmoleFHkHlHId9E7Pc/W/T 1319358695
Date: Sun, 23 Oct 2011 10:31:31 +0200
From: Greg KH <greg@kroah.com>
To: linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>, John Hawley <warthog19@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Linux 3.0.7 now on kernel.org
Message-ID: <20111023083131.GA13802@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I wanted to let people know that the 3.0.7 release is now downloadable
in patch and full-tarball form from kernel.org:
	http://www.kernel.org/pub/linux/kernel/v3.0/
as well as the incremental patches in the incr/ subdir:
	http://www.kernel.org/pub/linux/kernel/v3.0/incr/

ftp.kernel.org also works for those of you using that protocol.

You will note that the files are signed with my new kernel release
signing key, and that the .tar file is signed, and then compressed, so
there is not signatures for the individual compressed files.

For those of you caring and wanting to verify things, the fingerprint of
my signing key is:
	4096R/6092693E 2011-09-23
	Key fingerprint = 647F 2865 4894 E3BD 4571  99BE 38DB BDC8 6092 693E
	Greg Kroah-Hartman (Linux kernel stable release signing key) <greg@kroah.com>

The 3.0.5 and 3.0.6 releases are there as well if people want them.

I'll work on the older releases as we get time, that shouldn't be that
pressing of an issue at the moment.

Thanks so much to John and hpa for working hard on the tools and backend
configuration to make this possible.

thanks,

greg k-h
