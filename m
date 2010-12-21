Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932650Ab0LUAch (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 19:32:37 -0500
Received: from mail-fx0-f43.google.com ([209.85.161.43]:65291 "EHLO
	mail-fx0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752838Ab0LUAcg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 19:32:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=NwhUxQ9DlZVOSFs/ASQ5q8hYgkel8X4D9s1u4e1+cDk1DJYbGwxvmEUPhid2UcutpU
         g0rjBO7IoxYR4/Z8I2p4uFfDD4kh+yjJk+NpPNfFVS+H3XhHuyAH3ZDzPjHDsssKOByh
         aSOXHVaJeIXYu6fJXuJr9eXP3x9Sy13mz0C9g=
Date: Tue, 21 Dec 2010 01:31:42 +0100
From: "Carlos R. Mafra" <crmafra2@gmail.com>
To: Arnaud Lacombe <lacombar@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Michal Marek <mmarek@suse.cz>
Subject: Re: Build regression: unknown option "visible"
Message-ID: <20101221003142.GA23839@Pilar.aei.mpg.de>
References: <20101220172228.GA463@Pilar.aei.mpg.de>
 <AANLkTi=3WHB6iKaM5-=z33b9Nux7WyQ2K0apuRNwMhD=@mail.gmail.com>
 <20101220233002.GA1760@Pilar.aei.mpg.de>
 <AANLkTikvTL6SB0b6r2DQTUU5yu_9j4SUgmmjMiVmgamD@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTikvTL6SB0b6r2DQTUU5yu_9j4SUgmmjMiVmgamD@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mo 20.Dez'10 at 18:41:32 -0500, Arnaud Lacombe wrote:
> Hi,
> 
> On Mon, Dec 20, 2010 at 6:30 PM, Carlos R. Mafra <crmafra2@gmail.com> wrote:

> > Should I do a 'make clean' to get it back working?
> >
> yes.

Ah, it works now. Sorry about the noise.
