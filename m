Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753359Ab2DPL1U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 07:27:20 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:46902 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753213Ab2DPL1T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 07:27:19 -0400
Date: Mon, 16 Apr 2012 12:26:34 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andy Whitcroft <apw@canonical.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org, "K. Y. Srinivasan" <kys@microsoft.com>,
        Mike Sterling <Mike.Sterling@microsoft.com>
Subject: Re: [PATCH 0/2] Hyper-V disk support V3
Message-ID: <20120416122634.7d1357e1@ultron>
In-Reply-To: <1334575229-7493-1-git-send-email-apw@canonical.com>
References: <20120414170223.24f6ea31@pyramind.ukuu.org.uk>
	<1334575229-7493-1-git-send-email-apw@canonical.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Apr 2012 12:20:27 +0100
Andy Whitcroft <apw@canonical.com> wrote:

> Add support for ignoring disks devices on specific host controllers to
> libata.  Use this support to trigger us to ignore Hyper-V disk devices
> on the emulated SATA device based on the system DMI information.
> 
> Jeff, I believe the first patch is what you had in mind in your comments.
> Alan, the piix sadly has no subvendor/subdevice identifiers at all

So its 0x0000,0x0000 ?

> though we are able to detect the platform from the DMI information,
> this any better?

What happens if you have a PIIX device which is being passed through from
the underlying hardware or will hyper-v never support pass through ?

Alan
