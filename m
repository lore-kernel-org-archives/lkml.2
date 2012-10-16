Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753797Ab2JPOxc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 10:53:32 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:41420 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754233Ab2JPOxb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 10:53:31 -0400
Date: Tue, 16 Oct 2012 15:58:24 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Borislav Petkov <bp@amd64.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: ata4.00: failed to get Identify Device Data, Emask 0x1
Message-ID: <20121016155824.00d5b618@pyramind.ukuu.org.uk>
In-Reply-To: <20121016144932.GA24044@aftab.osrc.amd.com>
References: <20121016144932.GA24044@aftab.osrc.amd.com>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Oct 2012 16:49:32 +0200
Borislav Petkov <bp@amd64.org> wrote:

> Hi all,
> 
> a bunch of my boxes started showing this on 3.7-rc1 (and maybe earlier):
> 
> [    4.667077] ata4.00: failed to get Identify Device Data, Emask 0x1
> [    4.675071] ata4.00: failed to get Identify Device Data, Emask 0x1

Can you check whether 3.6 works on them. I know 3.6 is horribly broken on
several brands of AHCI controller (Jmicron for example). Dunno where Jeff
is on fixing the regressions ?

Alan
