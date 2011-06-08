Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753464Ab1FHMWs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 08:22:48 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:37171 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752016Ab1FHMWs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 08:22:48 -0400
Date: Wed, 8 Jun 2011 13:24:49 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Lukasz <el.es.cr@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [OT] Re: [PATCH 00/15] GMA500 KMS and GEM
Message-ID: <20110608132449.4a50b548@lxorguk.ukuu.org.uk>
In-Reply-To: <loom.20110608T130453-800@post.gmane.org>
References: <20110608100411.9478.86672.stgit@localhost.localdomain>
	<loom.20110608T130453-800@post.gmane.org>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> But I see the vblank (the feature that lets the (whatever space) programs 
> know when the vertical return occurs ?) as a quite useful thing...

Nothing much in the 2D world seems to use it for anything. In the 3D
world yes vblank syncing and page flipping is important, but the driver
is 2D only.

Alan
