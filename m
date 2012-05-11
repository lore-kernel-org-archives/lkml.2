Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964812Ab2EKJ60 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 05:58:26 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:39280 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932109Ab2EKJ6Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 05:58:25 -0400
Date: Fri, 11 May 2012 11:01:07 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: airlied@linux.ie, alan@linux.intel.com, kirill.shutemov@linux.intel.com,
        airlied@redhat.com, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] gma500: fix build when ACPI isn't set
Message-ID: <20120511110107.06d3e336@pyramind.ukuu.org.uk>
In-Reply-To: <CA+1xoqdp3N=hxF-bq0vCwUcyLuZ9wbpFiRJT2MjeBx=xQNgDJQ@mail.gmail.com>
References: <1336711142-26788-1-git-send-email-levinsasha928@gmail.com>
	<20120511104341.561ad95b@pyramind.ukuu.org.uk>
	<CA+1xoqdp3N=hxF-bq0vCwUcyLuZ9wbpFiRJT2MjeBx=xQNgDJQ@mail.gmail.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 May 2012 11:49:48 +0200
Sasha Levin <levinsasha928@gmail.com> wrote:

> On Fri, May 11, 2012 at 11:43 AM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> > Not btw that I imagine you could run a non ACPI kernel on a box new
> > enough to have a GMA500 8)
> 
> Probably not, but I saw more #ifdef CONFIG_ACPI below and assumed
> there's a good reason for that.
> 
> Out of curiously, is a scenario where a GMA500 is assigned to a KVM
> guest which doesn't have ACPI support plausible?

I doubt it - the GMA500 is doing direct memory access via the GTT and
hitting hardware level stuff. I don't believe any work has ever been done
for Imagination based graphics pass through.

Alan
