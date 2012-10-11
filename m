Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757616Ab2JKLBn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 07:01:43 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:58735 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755074Ab2JKLBl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 07:01:41 -0400
Date: Thu, 11 Oct 2012 20:01:35 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: Arun MURTHY <arun.murthy@stericsson.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCHv4 1/4] modem_shm: Add Modem Access Framework
Message-ID: <20121011110135.GE28546@kroah.com>
References: <1348819504-1303-1-git-send-email-arun.murthy@stericsson.com>
 <1348819504-1303-2-git-send-email-arun.murthy@stericsson.com>
 <20120928160045.GD2625@kroah.com>
 <F45880696056844FA6A73F415B568C695B6962C153@EXDCVYMBSTM006.EQ1STM.local>
 <20121001155940.GA1957@kroah.com>
 <F45880696056844FA6A73F415B568C695B6962CC8C@EXDCVYMBSTM006.EQ1STM.local>
 <20121003151748.GA5745@kroah.com>
 <F45880696056844FA6A73F415B568C695B697CB0C9@EXDCVYMBSTM006.EQ1STM.local>
 <20121009135918.GC5583@kroah.com>
 <F45880696056844FA6A73F415B568C695B9B3E3D8A@EXDCVYMBSTM006.EQ1STM.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <F45880696056844FA6A73F415B568C695B9B3E3D8A@EXDCVYMBSTM006.EQ1STM.local>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 11, 2012 at 11:37:20AM +0200, Arun MURTHY wrote:
> > On Tue, Oct 09, 2012 at 07:37:02AM +0200, Arun MURTHY wrote:
> > > Any further comments?
> > 
> > I was waiting for you to address all of the previous ones with a new set of
> > patches before burdening you with anything new :)
> 
> There are not any changes in the code, this review was more like just
> explaining our platform, protocol, few terminology and design approach.

That all needs to go into the patches you send next time around :)

And I thought I did have some actual code comments in there somewhere...

greg k-h
