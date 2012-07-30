Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755215Ab2G3WeK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 18:34:10 -0400
Received: from mga09.intel.com ([134.134.136.24]:33359 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755095Ab2G3WeI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 18:34:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="179512964"
Date: Mon, 30 Jul 2012 15:34:06 -0700
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Denis Turischev <denis@compulab.co.il>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 2/2] xhci: EHCI/XHCI ports switching on Intense-PC.
Message-ID: <20120730223406.GA9290@xanatos>
References: <5004454E.9030903@compulab.co.il>
 <20120717045416.GJ7599@xanatos>
 <50065E5A.2040103@compulab.co.il>
 <20120718165916.GA30828@xanatos>
 <500D3998.7010705@compulab.co.il>
 <20120723174406.GG32758@xanatos>
 <500E61E2.9080406@compulab.co.il>
 <20120724194609.GA6681@xanatos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120724194609.GA6681@xanatos>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Denis,

Can you send me the output of `sudo dmidecode`?  I'd like to see if I
can make a more general patch apply to the Intense-PC.

Sarah Sharp
