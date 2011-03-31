Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758296Ab1CaPYI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 11:24:08 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:48692 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758264Ab1CaPYE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 11:24:04 -0400
Date: Thu, 31 Mar 2011 16:24:38 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Ramya Desai <ramya.desai@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: GPL License Query on a Plain Linux Application
Message-ID: <20110331162438.3225d7a4@lxorguk.ukuu.org.uk>
In-Reply-To: <AANLkTi=aT2-ugOhDdSuh241PF-Sz-fFL1BkCUahoq0+o@mail.gmail.com>
References: <AANLkTi=aT2-ugOhDdSuh241PF-Sz-fFL1BkCUahoq0+o@mail.gmail.com>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 Mar 2011 20:49:34 +0530
Ramya Desai <ramya.desai@gmail.com> wrote:

> Dear All,
> 
> I have written an application where it uses plain system calls like
> open, read, write etc. and runs in the user space. My question here,
> is this application comes under GPL?

This is a technical not a legal list - I would ask the Linux Foundation
if you want a legal answer.

In general though your question seems really to be "is my application a
derivative work of the kernel". That would be a surprising interpretation
(speaking as a non-lawyer) but also one the community wanted to be sure
never occurred. Hence the COPYING file for the kernel itself states:

   NOTE! This copyright does *not* cover user programs that use kernel
 services by normal system calls - this is merely considered normal use
 of the kernel, and does *not* fall under the heading of "derived work".
 Also note that the GPL below is copyrighted by the Free Software
 Foundation, but the instance of code that it refers to (the Linux
 kernel) is copyrighted by me and others who actually wrote it.


Alan
