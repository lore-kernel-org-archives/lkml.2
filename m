Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758981Ab2EUSuF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 14:50:05 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:53842 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750894Ab2EUSuE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 14:50:04 -0400
Date: Mon, 21 May 2012 19:52:55 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: ivo.welch@gmail.com
Cc: ivo.welch@anderson.ucla.edu, linux-kernel@vger.kernel.org
Subject: Re: the easy way to sandbox?
Message-ID: <20120521195255.5b54f707@pyramind.ukuu.org.uk>
In-Reply-To: <CAPr7RtUBDn01qDkxvcLO8ZckAtTmCCJk7hCjwH4_XziwXtAS6Q@mail.gmail.com>
References: <CAPr7RtUBDn01qDkxvcLO8ZckAtTmCCJk7hCjwH4_XziwXtAS6Q@mail.gmail.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 May 2012 09:28:13 -0700
ivo welch <ivo.welch@anderson.ucla.edu> wrote:

> Suggestion:  introduce a system call that eliminates access to all
> real file systems for the current process.  the only permissible
> interaction would be stdin, stdout, and stderr.
> 
> this would make it very simple to write a sandboxed safe fcgi script.

No it wouldn't - because of things like ptrace.

Sandboxing done right is *hard*. SELinux and the other security setups
can do it. Containers can do interesting stuff in this space. Probably
the distros sometimes need to package the tools for it better.

Take a look at some of the cloud service code people have published.

Alan
