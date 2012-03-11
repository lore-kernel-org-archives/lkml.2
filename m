Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752847Ab2CKNmP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2012 09:42:15 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:40734 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751611Ab2CKNmO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2012 09:42:14 -0400
Date: Sun, 11 Mar 2012 13:44:05 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Carsten Emde <C.Emde@osadl.org>
Cc: David Airlie <airlied@linux.ie>, Thomas Gleixner <tglx@linutronix.de>,
        DRI <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] drivers-gpu-drm-allow-to-load-edid-firmware.patch
Message-ID: <20120311134405.05942964@pyramind.ukuu.org.uk>
In-Reply-To: <20120310202241.764367925@osadl.org>
References: <20120310202014.828058552@osadl.org>
	<20120310202241.764367925@osadl.org>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This patch allows to load an EDID data set via the firmware interface.
> It contains data sets of frequently used screen resolutions (1024x768,
> 1280x1024, 1680x1050 and 1920x1080). The requested EDID data are
> specified as a module parameter of the drm_kms_helper module, e.g.
> options drm_kms_helper edid_firmware=edid/1280x1024.bin or as kernel
> command line parameter.

What if the DRM layer and driver are compiled in. They'll come up as
console before the file system so the firmware request will hang ?


Given the EDID is tiny and is data not code wouldn't it be simpler (and
smaller) if this option compiled in a few generic EDIDs to use ?

Alan
