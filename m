Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753218Ab1H3KTR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 06:19:17 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:34123 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752160Ab1H3KTQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 06:19:16 -0400
Date: Tue, 30 Aug 2011 11:17:52 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Dan Carpenter <error27@gmail.com>
Cc: Mark Einon <mark.einon@gmail.com>, gregkh@suse.de,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        o.hartmann@telovital.com
Subject: Re: [PATCH 4/6] staging: et131x: Remove redundant replica loopback
 code
Message-ID: <20110830111752.0ad76a0d@lxorguk.ukuu.org.uk>
In-Reply-To: <20110830100834.GC3705@shale.localdomain>
References: <1314639761-4947-1-git-send-email-mark.einon@gmail.com>
	<1314639761-4947-4-git-send-email-mark.einon@gmail.com>
	<20110830100834.GC3705@shale.localdomain>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.4; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Aug 2011 13:08:34 +0300
Dan Carpenter <error27@gmail.com> wrote:

> This patch was sent with git-send-email but it's in base64 encoding.
> 
> Content-Type: text/plain; charset="utf-8"
> Content-Transfer-Encoding: base64
> 
> Why did that happen?

Presumably it got re-encoded because a mail system in the path between
him and you decided it was traversing a 7bit path and helpfully
reprocessed it to avoid corruption.

If your mailer can't automatically handle utf-8/base64 perhaps you need a
better one ;)

Alan
