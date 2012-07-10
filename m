Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755862Ab2GJPZM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 11:25:12 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:56951 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753630Ab2GJPZL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 11:25:11 -0400
Date: Tue, 10 Jul 2012 16:28:46 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Ortwin =?ISO-8859-1?B?R2z8Y2s=?= <odi@odi.ch>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mei: module version
Message-ID: <20120710162846.3c0f8ed7@pyramind.ukuu.org.uk>
In-Reply-To: <4FFBFF93.7030201@odi.ch>
References: <4FFBFF93.7030201@odi.ch>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Jul 2012 12:10:27 +0200
Ortwin Glück <odi@odi.ch> wrote:

> The LMS daemon expects a /sys/modules/mei/version file with, a four 
> digit version number.
> 
> see
> http://software.intel.com/en-us/articles/download-the-latest-intel-amt-open-source-drivers/

Just get them to fix the userspace. I thought the latest one had this
dealt with ?

