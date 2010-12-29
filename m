Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752930Ab0L2UCx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Dec 2010 15:02:53 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:46405 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752374Ab0L2UCw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Dec 2010 15:02:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=QXKsducWBs2GkBm/p2/WERjaXOT5fystC2HQ+qpTfxzmX9m9LQir9B9/0YILsflq4m
         QnDzcBr4tyeOv2O+aQ4vIleK5IOvbuJeE9B3+XquUF9Qo+iE/qaT13GrYBuV23ka4Ljt
         dDNTRyDW+E5mcKy8z2lBHhUokKiNUftfzpDnU=
Subject: Re: Kernel 2.6.37-rc5 rc7 Oops
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alex Arnautu <alex.arnautu96@gmail.com>,
        David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org
In-Reply-To: <AANLkTinJAEW-xAiEKnfxo1+3FiGwFXFii5Rh6d8tAtB-@mail.gmail.com>
References: <AANLkTinCD5Jf-dEUpv7hu4YKrxS0DGqqqBU94iCJ8602@mail.gmail.com>
	 <AANLkTinJAEW-xAiEKnfxo1+3FiGwFXFii5Rh6d8tAtB-@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 29 Dec 2010 21:02:45 +0100
Message-ID: <1293652965.7150.13.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 29 décembre 2010 à 11:23 -0800, Linus Torvalds a écrit :
> On Wed, Dec 29, 2010 at 4:26 AM, Alex Arnautu <alex.arnautu96@gmail.com> wrote:
> >
> > I get an oops with 2.6.37-rc5 and 2.6.37-rc7-git1.
> > http://www.fotoshack.us/fotos/19044P271210_15.14_[01].jpg
> 
> Hmm. Davem added to the list of people involved. This _may_ be fixed
> by the "always clone skbs" commit in -rc8 (commit 173021072), but
> David can make a better judgment call.
> 

Very unlikely, as commit 173021072 only fix a bug in case mirred is
used.

