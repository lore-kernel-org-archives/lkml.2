Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755737Ab1CaGHO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 02:07:14 -0400
Received: from one.firstfloor.org ([213.235.205.2]:33403 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751147Ab1CaGHM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 02:07:12 -0400
Date: Thu, 31 Mar 2011 08:07:11 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, stern@rowland.harvard.edu,
        ak@linux.intel.com, david-b@pacbell.net, gregkh@suse.de,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: Re: [PATCH] [115/275] OHCI: work around for nVidia shutdown problem
Message-ID: <20110331060711.GL21838@one.firstfloor.org>
References: <20110330203.501921634@firstfloor.org> <20110330210554.BE1633E1A05@tassilo.jf.intel.com> <AANLkTimr4nrkKgws_02wgtzWChjCuL3VhtBb4pyoe4Tq@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTimr4nrkKgws_02wgtzWChjCuL3VhtBb4pyoe4Tq@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 31, 2011 at 07:54:31AM +0200, Pali Rohár wrote:
> Hello,
> 
> please see comment 33 in LP bug tracker:
> https://bugs.launchpad.net/ubuntu/+source/linux/+bug/42149

Alan? Should I include http://marc.info/?l=linux-usb&m=130142049527638&w=2
too or drop this patch?

-Andi
