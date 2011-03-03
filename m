Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758960Ab1CCWHw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 17:07:52 -0500
Received: from lo.gmane.org ([80.91.229.12]:48965 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751251Ab1CCWHv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 17:07:51 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Stephen Hemminger <shemminger@vyatta.com>
Subject: Re: Network link detection
Date: Thu, 3 Mar 2011 14:07:33 -0800
Organization: Vyatta
Message-ID: <20110303140733.40307493@nehalam>
References: <20110303193006.GA29129@svh.nico22.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: 209.213.192.3
In-Reply-To: <20110303193006.GA29129@svh.nico22.de>
X-Newsreader: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simple answer is use netlink. That is what all real services use (NM, Quagga, ...)
Netlink can be hard to parse, so I recommend using a wrapper library.

Simplest example is the link-event example in libmnl
  http://www.netfilter.org/projects/libmnl/index.html


