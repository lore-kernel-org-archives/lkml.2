Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752401Ab2HaKA4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 06:00:56 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:39096 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752071Ab2HaKAz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 06:00:55 -0400
Date: Fri, 31 Aug 2012 11:04:44 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Matthieu CASTET <castet.matthieu@free.fr>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        gregkh@suse.de, sboyd@codeaurora.org, arnd@arndb.de,
        Matthieu Castet <matthieu.castet@parrot.com>
Subject: Re: [PATCH] hvc_dcc : add support to armv4 and armv5 core
Message-ID: <20120831110444.25d9b9fe@pyramind.ukuu.org.uk>
In-Reply-To: <1346404916-27616-1-git-send-email-castet.matthieu@free.fr>
References: <1346404916-27616-1-git-send-email-castet.matthieu@free.fr>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 31 Aug 2012 11:21:56 +0200
Matthieu CASTET <castet.matthieu@free.fr> wrote:

> Signed-off-by: Matthieu Castet <matthieu.castet@parrot.com>
> ---
>  drivers/tty/hvc/hvc_dcc.c |   34 ++++++++++++++++++++++++++++++++++
>  1 file changed, 34 insertions(+)

This is a step in the wrong direction. This should all be runtime handled

NAK.
