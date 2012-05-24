Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932987Ab2EXLIj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 07:08:39 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:58549 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932304Ab2EXLIi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 07:08:38 -0400
Date: Thu, 24 May 2012 12:10:56 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: Ming Lei <tom.leiming@gmail.com>, Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Alan Cox <alan@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: 3.4+ tty lockdep trace
Message-ID: <20120524121056.24fbdcdb@pyramind.ukuu.org.uk>
In-Reply-To: <CA+1xoqf0G3kDY3c4Gb=RkQZ8_L+but6-uUjtSVfvYUf6iL2_JA@mail.gmail.com>
References: <20120523002645.GA3490@redhat.com>
	<CACVXFVMz_GKHXpzbqt24yY=fHJ6uYZPOcSnKNFHrvbdpWxc7tw@mail.gmail.com>
	<CA+1xoqf0G3kDY3c4Gb=RkQZ8_L+but6-uUjtSVfvYUf6iL2_JA@mail.gmail.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I'm still seeing the warning with this patch:

Can you attach the trace that went with the trigger as well ?
