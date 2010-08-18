Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751343Ab0HRDxW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 23:53:22 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:63474 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750892Ab0HRDxQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 23:53:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=UYTfFFJ5KRDKKtlcZIqfZGGZgQ2rKN1THDKQcE00+bn2CGeyHplwevVOxcszlOe0cD
         vPc0d+b2XsoIKgXpwyenoQ1lRAlisrTYoN9UHQmuW84AYsMyPgGRyh9bpc4DAOvMFXSP
         UZfwA9qQTzVgVPx7D4dnxkOelmk4a8xZWbDOQ=
Date: Wed, 18 Aug 2010 05:53:12 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Borislav Petkov <bp@amd64.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>,
        Will Deacon <will.deacon@arm.com>, Paul Mundt <lethal@linux-sh.org>,
        David Miller <davem@davemloft.net>
Subject: Re: [RFC PATCH 0/0 v3] callchain fixes and cleanups
Message-ID: <20100818035310.GD24748@nowhere>
References: <1281991715-10367-1-git-send-regression-fweisbec@gmail.com> <20100817045820.GA676@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100817045820.GA676@aftab>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 17, 2010 at 06:58:20AM +0200, Borislav Petkov wrote:
> From: Frederic Weisbecker <fweisbec@gmail.com>
> Date: Mon, Aug 16, 2010 at 04:48:29PM -0400
> 
> Hey Frederic,
> 
> > Built-tested on PowerPc, Arm and SuperH (can someone point me to a
> > ready to use sparc cross compiler, like those that can be found there
> > for other archs: http://www.codesourcery.com/sgpp/lite_edition.html ?)
> 
> Have you by chance tried http://www.kernel.org/pub/tools/crosstool/
> already?


Nice, I'll give it a try.

Thanks :)

