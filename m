Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755430Ab0CPTSh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 15:18:37 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:4080 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754097Ab0CPTSd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 15:18:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=kcM0VwvqunIBowUXI5C4OuHvUGB8yXOw/CiWJ8L6tvgEVrqywop2bAJuen+VDgMDiq
         KDTp3AQFEfPWlT2jh6VZD0OwaYAj/e9tZGTz7jTloz/xo1yBNMFj/UBvo6psLcmxiS2J
         NKT22L10TSDbGWTi9AJ+U/RIUpG7Mq6l9Jbhw=
MIME-Version: 1.0
In-Reply-To: <87ljdsibqe.fsf@macbook.be.48ers.dk>
References: <87vdcwv139.fsf@tac.ki.iif.hu> <87ljdsibqe.fsf@macbook.be.48ers.dk>
Date: Tue, 16 Mar 2010 22:18:31 +0300
Message-ID: <acd2a5931003161218id7b0c4bp3b6dc366e4e56d5d@mail.gmail.com>
Subject: Re: RFC: direct MTD support for SquashFS
From: Vitaly Wool <vitalywool@gmail.com>
To: Peter Korsgaard <jacmet@sunsite.dk>
Cc: Ferenc Wagner <wferi@niif.hu>,
       Phillip Lougher <phillip@lougher.demon.co.uk>,
       linux-fsdevel@vger.kernel.org, linux-mtd@lists.infradead.org,
       linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 16, 2010 at 5:26 PM, Peter Korsgaard <jacmet@sunsite.dk> wrote:
>>>>>> "Ferenc" == Ferenc Wagner <wferi@niif.hu> writes:
>  Ferenc> For now, 2.6.34 gained pluggable decompressors, so this patch
>  Ferenc> does not apply anymore, though the main idea holds.  My
>  Ferenc> questions: is the community interested in integrating something
>  Ferenc> like this, should this patch transformed into something
>  Ferenc> acceptable, or am I a total lunatic?  I don't know a thing
>  Ferenc> about filesystem development, but willing to learn and
>  Ferenc> refactor.  Comments welcome.
>
> Nice, I have been thinking about that as well. What kind of size savings
> are you getting with this?

Yeah, I'm interested in that as well.

~Vitaly
