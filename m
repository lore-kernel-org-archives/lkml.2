Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755144Ab2D1VHU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2012 17:07:20 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:57796 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753644Ab2D1VHS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2012 17:07:18 -0400
Date: Sat, 28 Apr 2012 22:10:03 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Alexander Tarasikov <alexander.tarasikov@gmail.com>
Cc: linux-kernel@vger.kernel.org, airlied@linux.ie
Subject: Re: [PATCH] drivers:gpu:vga_switcheroo: Work around dramatic power
 drain in laptops
Message-ID: <20120428221003.49fb248d@pyramind.ukuu.org.uk>
In-Reply-To: <1335645928-30993-2-git-send-email-alexander.tarasikov@gmail.com>
References: <1335645928-30993-1-git-send-email-alexander.tarasikov@gmail.com>
	<1335645928-30993-2-git-send-email-alexander.tarasikov@gmail.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 	This patch adds an experimental module parameter that causes
> 	vga_switcheroo to disable all inactive VGA cards after a resume
> 	to save power and avoid lockups/GPU freezes. This has been tested
> 	on a Sony VAIO laptop with Intel HD3000 and Ati Radeon 6630M GPU.

The module parameter is probably the wrong long term option. Do you know
if the problem is general or specific to some laptops. If it's the latter
then it might also be worth implementing a DMI and/or PCI detection
routine to match the laptops you know are afflicted and automatically
enabled it.

Alan
