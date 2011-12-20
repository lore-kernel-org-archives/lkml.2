Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753282Ab1LTK1K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 05:27:10 -0500
Received: from gir.skynet.ie ([193.1.99.77]:53728 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751104Ab1LTK1F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 05:27:05 -0500
Date: Tue, 20 Dec 2011 10:26:50 +0000 (GMT)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] gma500: Final enables for Oaktrail
In-Reply-To: <20111219210615.27346.83876.stgit@bob.linux.org.uk>
Message-ID: <alpine.DEB.2.00.1112201026390.18890@skynet.skynet.ie>
References: <20111219210615.27346.83876.stgit@bob.linux.org.uk>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> This switches the ifdef to match the Kconfig so that Oaktrail probing occurs
> and adds some additional minor bulletproofing.
> 
> Tested on a Fujtisu Stylistic Q550 internal display. HDMI might work but that
> remains to be seen.
> 
> Signed-off-by: Alan Cox <alan@linux.intel.com> ---

Applied to -next.

Dave.
