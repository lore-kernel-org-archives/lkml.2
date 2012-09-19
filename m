Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756467Ab2ISNYM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 09:24:12 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:36170 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755518Ab2ISNYK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 09:24:10 -0400
Date: Wed, 19 Sep 2012 14:29:03 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jaeden Amero <jaeden.amero@ni.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND RESEND] compat_ioctl: Add RS-485 IOCTLs to the
 list
Message-ID: <20120919142903.5d7058ed@pyramind.ukuu.org.uk>
In-Reply-To: <1347994803-11032-1-git-send-email-jaeden.amero@ni.com>
References: <1345578069-13372-1-git-send-email-jaeden.amero@ni.com>
	<1347994803-11032-1-git-send-email-jaeden.amero@ni.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Sep 2012 14:00:03 -0500
Jaeden Amero <jaeden.amero@ni.com> wrote:

> The RS-485 TIOCSRS485 and TIOCGRS485 ioctls are 32-bit compatible, so
> in order to call them on 64-bit systems from 32-bit user mode, we add
> them to the ioctl pointer list as compatible ioctls.
> 
> Signed-off-by: Jaeden Amero <jaeden.amero@ni.com>

Added to my tty pile as nobody seems to be able to decide who owns this
