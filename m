Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753068Ab0I3Kbu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 06:31:50 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:34745 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751558Ab0I3Kbt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 06:31:49 -0400
Date: Thu, 30 Sep 2010 11:56:16 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Marc - A. Dahlhaus" <mad@wol.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix capi devicenames
Message-ID: <20100930115616.633caf91@lxorguk.ukuu.org.uk>
In-Reply-To: <AANLkTik0DXVYgiDV0zy-m4kcsvX6X3j-8sGW4H_YT+x6@mail.gmail.com>
References: <4CA391B3.1030806@wol.de>
	<20100930103010.1a6a7785@lxorguk.ukuu.org.uk>
	<AANLkTik0DXVYgiDV0zy-m4kcsvX6X3j-8sGW4H_YT+x6@mail.gmail.com>
Followup-To: Kay Sievers <kay.sievers@vrfy.org>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

O> devices.txt is just wrong in some things, and the common userspace
> usage pattern is much closer to be a 'standard' here than this file.
> devices.txt should catch up here. The same is true for scdX vs. srX,
> scdX nodes don't exist today, and srX is not at all deprecated, unlike
> devices.txt states.

devices.txt is the spec.

> The kernel provided ISDN nodes never made sense for applications using
> ISDN. Also the devices.txt node names, I've never seen anywhere else
> than in devices.txt.

Doesn't matter - changing them will cause regressions.

If people want to rename them in userspace then fine, but changing the
default names for device nodes is not something to do lightly. You'll
break stuff for people who do follow the spec.

So NAK, and that's with the devices@lanana.org keeper of the device name
mappings hat on.

Alan
