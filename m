Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753787Ab0FWPyy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 11:54:54 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:54704 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752967Ab0FWPyw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 11:54:52 -0400
Date: Wed, 23 Jun 2010 16:59:36 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andi Kleen <andi@firstfloor.org>
Cc: Kees Cook <kees.cook@canonical.com>, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v2] security: Yama LSM
Message-ID: <20100623165936.661744f8@lxorguk.ukuu.org.uk>
In-Reply-To: <20100623153408.GA15787@basil.fritz.box>
References: <20100623065236.GH5876@outflux.net>
	<877hlqas9e.fsf@basil.nowhere.org>
	<20100623145437.GJ5876@outflux.net>
	<20100623153408.GA15787@basil.fritz.box>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > I actually think this is a flaw in get_task_comm.  (Though actually it's
> > the fault of terminals if they process dangerous escape sequences. Worst
> > case tends to just be confusing output, but that's not important --
> > nothing should spew non-printables regardless.)  Would a patch to
> > get_task_comm be accepted to replace non-printables with "?" or something
> > when filling the buffer?
> 
> Probably makes sense, although you might annoy someone who wants Kanji
> process names in UTF-8 or similar.

The task name is irrelevant, user controlled information. It's not
really ideal for use in security logging.

Alan

