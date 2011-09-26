Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753248Ab1IZKQi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 06:16:38 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:54127 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753136Ab1IZKQh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 06:16:37 -0400
Date: Mon, 26 Sep 2011 11:15:22 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Arun <engineerarun@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Detection of Advanced Format drives
Message-ID: <20110926111522.2a053ceb@lxorguk.ukuu.org.uk>
In-Reply-To: <CANLaLhaEnyPchqOPp65Y0hvotM30E5daX=XNG=fAAmf1dchxCA@mail.gmail.com>
References: <CANLaLhaEnyPchqOPp65Y0hvotM30E5daX=XNG=fAAmf1dchxCA@mail.gmail.com>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.4; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Sep 2011 15:25:52 +0530
Arun <engineerarun@gmail.com> wrote:

> Is there any way to detect the Advanced Format hard drives with 4K
> sector size? I understand that above kernel v. 2.6.31 it is supported.
> But is it possible detect automatically if the drive is an AF drive
> and how?

It's in the drive identify data (see the ATA 8 specification documents)

