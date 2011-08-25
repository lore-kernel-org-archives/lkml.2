Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752837Ab1HYO4M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 10:56:12 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:39774 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751612Ab1HYO4I convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 10:56:08 -0400
Date: Thu, 25 Aug 2011 15:54:56 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Dawid =?UTF-8?B?Q2nEmcW8YXJraWV3aWN6?= <dawidc@b-labs.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Problem with writing virtual serial device driver.
Message-ID: <20110825155456.4784f16d@lxorguk.ukuu.org.uk>
In-Reply-To: <CAHzZGEz3EYuQQA0BK0Z9L14BXzuYRV4WVHS+6=L9rBwx+_G_8A@mail.gmail.com>
References: <CAHzZGEz3EYuQQA0BK0Z9L14BXzuYRV4WVHS+6=L9rBwx+_G_8A@mail.gmail.com>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.4; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Aug 2011 11:29:21 +0200
Dawid Ciężarkiewicz <dawidc@b-labs.com> wrote:

> Hi,
> 
> I'm working on virtual serial driver for paravirtualized Linux instance.
> 
> I'm using documentation available on the web and doing mostly fine,
> but hit some weird issue.
> 
> The problem is: my driver successfully registers serial device, the
> appropriate devices get created under /dev, but no matter what I do
> with the

The first question would be what error code you get when you try and open
your new device, that would tell you much, and help identify your problem.
