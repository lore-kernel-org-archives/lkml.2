Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751531Ab1EHLv6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 May 2011 07:51:58 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:64788 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750949Ab1EHLvy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 May 2011 07:51:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=qHDFVt4qtg3ErIRXVodIGH1fKEcq3tpftp0C2T1vzOPU8KUlfmJHyaySQ4JN+KwWjN
         tPvysEK6teBS2H3XI/adXHijCsyPQKNrgf5q3oD8PIpRmUEWY9LMiaGU206CVsuzupeT
         BUdDlSH2TdPcejNpe0YC59D1DZNeC1PR1kUQE=
MIME-Version: 1.0
In-Reply-To: <20110507154307.GE23672@kroah.com>
References: <BANLkTik9e5it5vTMxvFUnZGpoO8N0ida8Q@mail.gmail.com>
	<op.vuynsdh13l0zgt@mnazarewicz-glaptop>
	<BANLkTinxvtMUcFz9T7L1iq9pFUx8ocQnRQ@mail.gmail.com>
	<20110507010927.GA32142@kroah.com>
	<BANLkTikPgm7kpaoofVSkJCBXYyea4HeB8A@mail.gmail.com>
	<20110507154307.GE23672@kroah.com>
Date: Sun, 8 May 2011 14:51:53 +0300
Message-ID: <BANLkTikzqykV-TxmTb-wVAVxEj-_MBqx9g@mail.gmail.com>
Subject: Re: [PATCH] usb: gadget: f_mass_storage: Remove the LUN check which
 is always true
From: Maxin John <maxin.john@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: Michal Nazarewicz <mina86@mina86.com>, gregkh@suse.de,
        stern@rowland.harvard.edu, m-sonasath@ti.com,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        roger.quadros@nokia.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

On Sat, May 7, 2011 at 6:43 PM, Greg KH <greg@kroah.com> wrote:
> On Sat, May 07, 2011 at 12:27:58PM +0300, Maxin John wrote:
>> Hi Greg,
>
> Ok, but you forgot a changelog entry and a good subject line.

Oh.. my mistake. I forgot to update it.. Sorry.

> Care to redo this in a format that I don't have to edit it in order to
> be able to apply it properly?

I think, I should blame Gmail for this.  I have switched to "mutt" as
it seems to work fine for me now. I will re-send the merged patch based
on your suggestions.

Thanks,
Maxin
