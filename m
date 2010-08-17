Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758135Ab0HQSNZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 14:13:25 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:34907 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753145Ab0HQSNX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 14:13:23 -0400
Date: Tue, 17 Aug 2010 19:28:06 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Bobby Crabtree <bobbyc@codeaurora.org>
Cc: broonie@opensource.wolfsonmicro.com, lrg@slimlogic.co.uk,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
Subject: Re: regulator voltage aggregation
Message-ID: <20100817192806.09744719@lxorguk.ukuu.org.uk>
In-Reply-To: <4C6ACF92.7050506@codeaurora.org>
References: <4C6ACF92.7050506@codeaurora.org>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

O> int regulator_set_optimum_voltage(struct regulator *regulator,
>                 int min_uV, int max_uV);

Pedantic hat on - how can it be optimum if its a range ? (and an
adjective but that is really pedantic) ;))

Surely it's not the optimal value, it's the range at which it works at
all you are defining (between off, and escaping smoke).

set_voltage_range() sounds rather more natural to me.

Alan
