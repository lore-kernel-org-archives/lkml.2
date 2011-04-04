Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754098Ab1DDJAV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 05:00:21 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:34917 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751890Ab1DDJAU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 05:00:20 -0400
Date: Mon, 4 Apr 2011 10:00:55 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jan Engelhardt <jengelh@medozas.de>
Cc: gregkh@suse.de, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: staging: gma500: fix "persistant" typo
Message-ID: <20110404100055.4c696801@lxorguk.ukuu.org.uk>
In-Reply-To: <alpine.LNX.2.01.1104040129110.21333@obet.zrqbmnf.qr>
References: <alpine.LNX.2.01.1104040129110.21333@obet.zrqbmnf.qr>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 Apr 2011 01:29:32 +0200 (CEST)
Jan Engelhardt <jengelh@medozas.de> wrote:

> parent b0ef5d4e28cd127eef94b300f27ba0104deb5ad6 (v2.6.39-rc1-186-gb0ef5d4)
> commit fdbba80c7a1638bb2041d6349db27762e951a074
> Author: Jan Engelhardt <jengelh@medozas.de>
> Date:   Mon Apr 4 01:28:05 2011 +0200
> 
> staging: gma500: fix "persistant" typo

None of these files exist any more in the current gma500 code
