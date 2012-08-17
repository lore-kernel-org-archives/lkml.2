Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754764Ab2HQNbx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 09:31:53 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:50580 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753054Ab2HQNbp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 09:31:45 -0400
Date: Fri, 17 Aug 2012 14:36:22 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: mathieu.poirier@linaro.org
Cc: linux-kernel@vger.kernel.org, arve@android.com, kernel-team@android.com,
        dmitry.torokhov@gmail.com, john.stultz@linaro.org
Subject: Re: [PATCH] [RFC]: drivers/tty: Folding Android's keyreset driver
 in sysRQ
Message-ID: <20120817143622.4e98a63a@pyramind.ukuu.org.uk>
In-Reply-To: <1345154810-1509-1-git-send-email-mathieu.poirier@linaro.org>
References: <1345154810-1509-1-git-send-email-mathieu.poirier@linaro.org>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This functionality comes from the keyreset driver submitted by
> Arve Hjønnevåg in the Android kernel.  It is sent out as an initial
> draft and comments are welcomed.

Looks reasonable to me as a basis.

Alan
