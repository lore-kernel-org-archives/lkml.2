Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967464Ab2EPL36 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 07:29:58 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:46793 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030195Ab2EPL3z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 07:29:55 -0400
Date: Wed, 16 May 2012 12:32:46 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Andre Hedrick (anhedric)" <anhedric@cisco.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: Re: CFA 4.0 patch
Message-ID: <20120516123246.325c9ba9@pyramind.ukuu.org.uk>
In-Reply-To: <4E75C4FECC27A44E9F7E0737D71946900F686DB5@xmb-sjc-21e.amer.cisco.com>
References: <4E75C4FECC27A44E9F7E0737D71946900F686C61@xmb-sjc-21e.amer.cisco.com>
	<20120515153818.3e70d845@pyramind.ukuu.org.uk>
	<4E75C4FECC27A44E9F7E0737D71946900F686DB5@xmb-sjc-21e.amer.cisco.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 May 2012 11:35:57 -0700
"Andre Hedrick (anhedric)" <anhedric@cisco.com> wrote:

> Hi Alan,
> 
> You betcha, otherwise I would not have a case.
> 
> STEC configed to MWDMA4 (Max reported as UDMA/66)

Both of these however should have the identify data indicating CF ? Do
they also have word 83 not reporting them as CFA ?


