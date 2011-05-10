Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752991Ab1EJVor (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 17:44:47 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:54416 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751361Ab1EJVop (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 17:44:45 -0400
Date: Tue, 10 May 2011 22:46:02 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
Cc: alan@linux.intel.com, greg@kroah.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] gma500: Add option to disable LVDS
Message-ID: <20110510224602.73b24d0a@lxorguk.ukuu.org.uk>
In-Reply-To: <20110510212038.GA3279@patrik-macbook>
References: <20110510212038.GA3279@patrik-macbook>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 May 2011 23:20:38 +0200
Patrik Jakobsson <patrik.r.jakobsson@gmail.com> wrote:

> This patch adds the option to load the driver without LVDS support. Some platforms with the gma500 have nothing hooked up to LVDS but only uses SDVO. LVDS is still detected and added as an encoder which causes SDVO mode-setting to fail.
> 
> Signed-off-by: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>

What platform is this - I'd really like to keep such things automatic and
also if possible make the code handle the case not blow up. The user
shouldn't have to deal with such funnies.

Alan
