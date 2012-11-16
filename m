Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752502Ab2KPPjZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 10:39:25 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:56052 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752353Ab2KPPjY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 10:39:24 -0500
Date: Fri, 16 Nov 2012 15:44:43 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Forconi <forconi@wavecomm.it>
Cc: linux-kernel@vger.kernel.org
Subject: Re: KMS Framebuffer on Intel N2600 (GMA3600)
Message-ID: <20121116154443.46b21508@pyramind.ukuu.org.uk>
In-Reply-To: <2005140186.1409370.1353077454668.JavaMail.root@zmail.sgconsulting.it>
References: <20121115125749.3604ebdf@pyramind.ukuu.org.uk>
	<2005140186.1409370.1353077454668.JavaMail.root@zmail.sgconsulting.it>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Nov 2012 14:50:54 +0000 (UTC)
Forconi <forconi@wavecomm.it> wrote:

> Hi Alan,
> I wasn't be able to make the Linux Framebuffer run on my kernel, even if the kernel config seems to be correct.
> I have decided to give a try to ubuntu-server because many users report to make their netbook screen work with cedarview-drm driver.
> To be short, I installed ubuntu-server, installed a non-pae kernel (3.2.0.33), installed cedarview-drm package and configured grub with video=LVDS-1:d.
> Framebuffer is up and running now with 800x480 resolution. I haven't investigated yet why ubuntu driver works and the one I built wit the 3.6.6 kernel not.

Glad to hear that. Can you let me know the version number of the
cedarview-drm driver you are using. That helps me as the open source
driver is derived from that code so I know if you've got a newer version
for example.

Alan
