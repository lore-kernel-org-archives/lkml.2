Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751394Ab2G0JuU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 05:50:20 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:50089 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751011Ab2G0JuS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 05:50:18 -0400
Date: Fri, 27 Jul 2012 10:53:57 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Andrew Stiegmann (stieg)" <astiegmann@vmware.com>
Cc: linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org,
        pv-drivers@vmware.com, vm-crosstalk@vmware.com, cschamp@vmware.com,
        gregkh@linuxfoundation.org
Subject: Re: [vmw_vmci 11/11] Apply the header code to make VMCI build
Message-ID: <20120727105357.2e40dd10@pyramind.ukuu.org.uk>
In-Reply-To: <1343345980-32397-12-git-send-email-astiegmann@vmware.com>
References: <1343345980-32397-1-git-send-email-astiegmann@vmware.com>
	<1343345980-32397-12-git-send-email-astiegmann@vmware.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +enum {
> +	VMCI_SUCCESS_QUEUEPAIR_ATTACH	=  5,
> +	VMCI_SUCCESS_QUEUEPAIR_CREATE	=  4,
> +	VMCI_SUCCESS_LAST_DETACH	=  3,
> +	VMCI_SUCCESS_ACCESS_GRANTED	=  2,
> +	VMCI_SUCCESS_ENTRY_DEAD	=  1,

We've got a nice collection of Linux error codes than you, and it would
make the driver enormously more readable on the Linux side if as low
level as possible it started using Linux error codes.


> +	VMCI_SUCCESS			=  0,
> +	VMCI_ERROR_INVALID_RESOURCE	= (-1),
> +	VMCI_ERROR_INVALID_ARGS	= (-2),
> +	VMCI_ERROR_NO_MEM		= (-3),
> +	VMCI_ERROR_DATAGRAM_FAILED	= (-4),
> +	VMCI_ERROR_MORE_DATA		= (-5),
> +	VMCI_ERROR_NO_MORE_DATAGRAMS	= (-6),
> +	VMCI_ERROR_NO_ACCESS		= (-7),
> +	VMCI_ERROR_NO_HANDLE		= (-8),
> +	VMCI_ERROR_DUPLICATE_ENTRY	= (-9),
> +	VMCI_ERROR_DST_UNREACHABLE	= (-10),
> +	VMCI_ERROR_PAYLOAD_TOO_LARGE	= (-11),
> +	VMCI_ERROR_INVALID_PRIV	= (-12),
