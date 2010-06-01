Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754429Ab0FAKUz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 06:20:55 -0400
Received: from ey-out-2122.google.com ([74.125.78.26]:22439 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752313Ab0FAKUx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 06:20:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=bT2Yjb48iEu+6k+GC+t/ysybT4sKkHbJ43QEwf4tIbYH6swjFieTmZ6gDXKqHDUuYU
         HwipwdwL8viqdXrMqEBvYY2ka1Dc/Rsagt6oCv/eYe/dl4782MuHf8qfdhVq2YfRncEu
         tfE0UPHgL5a7CSRBLSxCm20pOYMZWbVhBsEcE=
MIME-Version: 1.0
In-Reply-To: <20100529021624.GA2538@brick.ozlabs.ibm.com>
References: <2d460de71003260850x7f90d04cy79ac853464108182@mail.gmail.com>
	<20100326160226.0159ac3b@lxorguk.ukuu.org.uk>
	<4BACE827.4070006@gmail.com>
	<20100326170428.6c1ad66c@lxorguk.ukuu.org.uk>
	<4BB31E00.8060204@netservers.co.uk>
	<20100529021624.GA2538@brick.ozlabs.ibm.com>
Date: Tue, 1 Jun 2010 12:20:51 +0200
Message-ID: <AANLkTil7fk_ikrSPiZnqcJSLGCrzcCrCwbeuUMY5Yu5v@mail.gmail.com>
Subject: Re: [Patch] fix packet loss and massive ping spikes with PPP 
	multi-link
From: Richard Hartmann <richih.mailinglist@gmail.com>
To: Paul Mackerras <paulus@samba.org>
Cc: Ben McKeegan <ben@netservers.co.uk>, netdev@vger.kernel.org,
       linux-ppp@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "Alexander E. Patrakov" <patrakov@gmail.com>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 29, 2010 at 04:16, Paul Mackerras <paulus@samba.org> wrote:


> I'll
> ack it and hopefully DaveM will pick it up.

As 2.6.35-rc1 is out, does this mean that we are looking at 2.6.36 at the
earliest? Or could this make it in as it is

a) a bug fix
b) tested in the field
c) a small change


Thanks,
Richard
