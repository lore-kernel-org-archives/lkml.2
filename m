Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754183Ab1CKNy7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 08:54:59 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:54113 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753115Ab1CKNy6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 08:54:58 -0500
Date: Fri, 11 Mar 2011 13:55:02 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, arnd@arndb.de
Subject: Re: [PATCH 3/3] tty: serial: Check UPF_FOURPORT, when
 CONFIG_SERIAL_8250_FOURPORT is defined
Message-ID: <20110311135502.1add15c9@lxorguk.ukuu.org.uk>
In-Reply-To: <1299848292-17101-3-git-send-email-nobuhiro.iwamatsu.yj@renesas.com>
References: <1299848292-17101-1-git-send-email-nobuhiro.iwamatsu.yj@renesas.com>
	<1299848292-17101-3-git-send-email-nobuhiro.iwamatsu.yj@renesas.com>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Mar 2011 21:58:12 +0900
Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com> wrote:

> When CONFIG_SERIAL_8250_FOURPORT is defined, driver uses UPF_FOURPORT in port.flags.
> Though CONFIG_SERIAL_8250_FOURPORT is not defined, there is a case to check UPF_FOURPORT.
> When CONFIG_SERIAL_8250_FOURPORT is defined only, this checks UPF_FOURPORT.

Again all this can be avoided by defining WARN traps for the unsupported
I/O methods in your architecture.

Alan
