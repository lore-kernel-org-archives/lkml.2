Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759313Ab2HXM0X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 08:26:23 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:59789 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751646Ab2HXM0S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 08:26:18 -0400
Date: Fri, 24 Aug 2012 13:30:33 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: David Ahern <dsahern@gmail.com>, Pekka Enberg <penberg@kernel.org>,
        Bernhard Rosenkraenzer <bernhard.rosenkranzer@linaro.org>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCHv2 1/1] perf: Port to Android
Message-ID: <20120824133033.3d93cf5f@pyramind.ukuu.org.uk>
In-Reply-To: <20120824040845.GA3001@srcf.ucam.org>
References: <1408973.PFKjjaXiS1@localhost.localdomain>
	<CAOJsxLFgvqJUwwnrtH8b9eOfNzUEZDmQGP1FVvToitD6ayYP0g@mail.gmail.com>
	<5036A182.7030707@gmail.com>
	<20120824040845.GA3001@srcf.ucam.org>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Aug 2012 05:08:45 +0100
Matthew Garrett <mjg59@srcf.ucam.org> wrote:

> On Thu, Aug 23, 2012 at 03:32:50PM -0600, David Ahern wrote:
> 
> > Why not add support for the missing functions (on_exit, getsid,
> > psignal and getline) to Bionic instead of perf?
> 
> Many vendors need to target existing Android platforms and don't have 
> the luxury of waiting for code to get through Google review and then 
> land on devices between 6 months in the future and never. The embedded 
> world is dysfunctional in a whole bunch of ways.

So add a small library and link with -lstuffandroidforgot. That's
basically how the FSF dealt with all the proprietary Unix library messes. 

Come to think of it call the library "integrated build runtime
environment" and you can like with -libre ;)

It's also going to be far more maintainable and generically useful for
porting tools from GNU to 'droid userspace.

Alan

