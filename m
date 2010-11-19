Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753700Ab0KSL24 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 06:28:56 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:49309 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753529Ab0KSL2z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 06:28:55 -0500
Date: Fri, 19 Nov 2010 11:27:49 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: parveen jain <parveenj16@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Unknown error 513 in pthread_create after several hours of
 running a Gstreamer based application
Message-ID: <20101119112749.69c19a69@lxorguk.ukuu.org.uk>
In-Reply-To: <AANLkTikU_HUXEoXuRAn0zoRmVke_32AWdqwC8fhkK0tZ@mail.gmail.com>
References: <AANLkTikK9f0xzVUmO7g0ztq+wtEVX3y7ntq7zXgD5kqa@mail.gmail.com>
	<AANLkTikU_HUXEoXuRAn0zoRmVke_32AWdqwC8fhkK0tZ@mail.gmail.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 1536 KB as my stack size for each of these threads. I have one
> Quadcore(intel Xeon) system of around 8 GB of RAM(64 bit) with RHEL
> 5.5(kernel - 2.6.18-92.el5).

RHEL is a very old and customised kernel, it's not a standard current
Linux kernel. You should contact your Red Hat support.

