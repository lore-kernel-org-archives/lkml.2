Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752294Ab1ECK2l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 06:28:41 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:44084 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752179Ab1ECK2k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 06:28:40 -0400
Date: Tue, 3 May 2011 11:29:51 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jimmy Chen (=?big5?B?s6+lw7lG?=) <jimmy.chen@moxa.com>
Cc: <linux-kernel@vger.kernel.org>, <linux-watchdog@vger.kernel.org>,
        <wim@iguana.be>
Subject: Re: [PATCH 2/2] watchdog: add support for MOXA V2100 watchdog
 driver
Message-ID: <20110503112951.1f6b7533@lxorguk.ukuu.org.uk>
In-Reply-To: <ECB3782BB8F03341905DD923270296115F720B@mhqms01.moxa.com>
References: <20110503103704.69aba5b2@lxorguk.ukuu.org.uk>
	<ECB3782BB8F03341905DD923270296115F720B@mhqms01.moxa.com>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=big5
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 May 2011 18:25:50 +0800
Jimmy Chen (³¯¥Ã¹F) <jimmy.chen@moxa.com> wrote:

> From: Jimmy Chen <jimmy.chen@moxa.com>
> 
> -Add real function for watchdog driver
> -Follow advices from Alan Cox
> 
> Signed-off-by: Jimmy Chen <jimmy.chen@moxa.com>

Acked-by: Alan Cox <alan@linux.intel.com>
