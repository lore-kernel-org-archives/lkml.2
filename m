Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753949Ab1EEMWg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 08:22:36 -0400
Received: from wolff.to ([65.117.131.163]:44004 "HELO wolff.to"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751426Ab1EEMWf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 08:22:35 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Thu, 05 May 2011 08:22:35 EDT
Date: Thu, 5 May 2011 07:12:27 -0500
From: Bruno Wolff III <bruno@wolff.to>
To: linux-kernel@vger.kernel.org
Subject: Thank you: Phillip Lougher and Lasse Collin
Message-ID: <20110505121227.GA13727@wolff.to>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'd like to publicly thank Phillip Lougher and Lasse Collin for their
work developing XZ compression for squashfs and getting it in the upstream
kernel, allowing its use in Fedora.

This change has kept us from having to cut packages from the Live Desktop
(gnome), KDE and Games spins as these spins had been growing in size
each release and were going to be too big for Fedora 15 without the
space savings of XZ relative to GZIP. For Fedora 16 we will be also using
a squashfs image to reduce the memory requirements of anaconda and having
the ability to use XZ instead of GZIP will provide significant savings
there as well.

Thanks for making linux better!
