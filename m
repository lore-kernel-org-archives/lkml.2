Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752489Ab1ARK6H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 05:58:07 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:57659 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752212Ab1ARK6F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 05:58:05 -0500
Date: Tue, 18 Jan 2011 10:57:37 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: donna.rigas@dynonavionics.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: serial port programming second question (newbie)
Message-ID: <20110118105737.3ff91a39@lxorguk.ukuu.org.uk>
In-Reply-To: <4D34E1C2.1000602@gmail.com>
References: <4D34DE89.4030705@gmail.com>
	<4D34E1C2.1000602@gmail.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Jan 2011 16:41:38 -0800
Donna Rigas <donna.rigas@gmail.com> wrote:

> Also, if your call to tcsetattr fails, or if  the ioctl call to
> set the baud rate fails, does it matter if you restore the serial
> port settings or not?

If they fail the returned struct contains the settings you ended up with,
eg the baud rate you actually got. Older kernels didn't get that detail
right but current ones do. Generally they will try and pick a nearest
suitable rate.

Alan
