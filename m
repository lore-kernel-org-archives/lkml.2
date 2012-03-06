Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758869Ab2CFVfR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 16:35:17 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:37980 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757578Ab2CFVfO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 16:35:14 -0500
Date: Tue, 6 Mar 2012 21:37:06 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Eric Andersson <eric.andersson@unixphere.com>
Cc: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org, arnd@arndb.de,
        zhengguang.guo@bosch-sensortec.com, peter.moeller@cn.bosch.com
Subject: Re: [PATCHv2 3/3] misc: rename bmp085 to bmp18x
Message-ID: <20120306213706.75eb78f1@pyramind.ukuu.org.uk>
In-Reply-To: <1331068084-17911-4-git-send-email-eric.andersson@unixphere.com>
References: <1331068084-17911-1-git-send-email-eric.andersson@unixphere.com>
	<1331068084-17911-4-git-send-email-eric.andersson@unixphere.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  6 Mar 2012 22:08:04 +0100
Eric Andersson <eric.andersson@unixphere.com> wrote:

> The bmp085 chip has been deprecated by the newer bmp18x chip family from
> Bosch Sensortec.

And yo risk breaking existing systems by renaming it. Are you going to
rename it again when the 285, 385, 485 come out ?

By all means change the description but leave the Kconfig and module name
alone. It's gratuitious breakage and config file frobbing otherwise.

Alan
