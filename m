Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933105Ab1JNTdZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 15:33:25 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:43514 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933033Ab1JNTdX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 15:33:23 -0400
Date: Fri, 14 Oct 2011 20:31:38 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Grant Grundler <grundler@google.com>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
        Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org, "Gwendal Grignou `" <gwendal@google.com>
Subject: Re: [PATCH] libata: fix for transport xfer attributes
Message-ID: <20111014203138.5d3460d5@lxorguk.ukuu.org.uk>
In-Reply-To: <CANEJEGtzwQkDG1KmqVizmW8=SWuhYgjH02TgLaQzU-76TYUZZg@mail.gmail.com>
References: <201110132203.45394.bzolnier@gmail.com>
	<4E9762DE.1060009@pobox.com>
	<201110141158.33983.bzolnier@gmail.com>
	<CANEJEGtzwQkDG1KmqVizmW8=SWuhYgjH02TgLaQzU-76TYUZZg@mail.gmail.com>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.4; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>     "xfer_mode   Current transfer mode."
> 
> I agree with Bartomiej that current behavior is incorrect.

Well we should probably fix the document and add the current transfer
mode as its own sysfs entry - much less risky.
