Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754389Ab2DRUKA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 16:10:00 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:37588 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751065Ab2DRUJ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 16:09:57 -0400
Date: Wed, 18 Apr 2012 21:12:35 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: KY Srinivasan <kys@microsoft.com>
Cc: Andy Whitcroft <apw@canonical.com>, Jeff Garzik <jgarzik@pobox.com>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mike Sterling <mike.sterling@microsoft.com>
Subject: Re: [PATCH 0/2] Hyper-V disk support V3
Message-ID: <20120418211235.55b9befc@pyramind.ukuu.org.uk>
In-Reply-To: <426367E2313C2449837CD2DE46E7EAF92CE0B5@CH1PRD0310MB381.namprd03.prod.outlook.com>
References: <20120414170223.24f6ea31@pyramind.ukuu.org.uk>
	<1334575229-7493-1-git-send-email-apw@canonical.com>
	<20120416122634.7d1357e1@ultron>
	<20120416182927.GB3346@shadowen.org>
	<426367E2313C2449837CD2DE46E7EAF92CE0B5@CH1PRD0310MB381.namprd03.prod.outlook.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The notion of "pass through" in Hyper-V  is a little different. IDE devices can be configured
> under either one of the supported controllers and these devices can either be virtual disks
> (VHDs) or physical disks. In either case these will be presented to the guest as IDE devices.

So what ensures that by skipping it at the ATA device level we will
always find it as a VHD ?

Alan
