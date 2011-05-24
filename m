Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756304Ab1EXNGk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 09:06:40 -0400
Received: from sparky.wurtel.net ([81.171.37.211]:44495 "EHLO mx.wurtel.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756274Ab1EXNGi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 09:06:38 -0400
Date: Tue, 24 May 2011 15:06:21 +0200
From: Paul Slootman <paul@wurtel.net>
To: linux-kernel@vger.kernel.org
Subject: Re: [stable] apparent regression (crash) - 2.6.38.6
Message-ID: <20110524130620.GA16055@msgid.wurtel.net>
Mail-Followup-To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Wurtel-Bad-Headers: Message headers fail syntax check
X-Wurtel-No-Sender: No verifiable sender address in message headers
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 2.6.39 was released without it ;/

I noticed that 2.6.39 crashes on my system if I have a CDROM in the
drive (PATA) during booting.  Perhaps related?
Screen photo: http://corky.wurtel.net/~paul/panic-boot-2.6.39.jpg

2.6.39 also crashes after half a day :-(
Photo of the panic at
http://corky.wurtel.net/~paul/panic-2.6.39.jpg

Paul
