Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754466Ab0K2Pcm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 10:32:42 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:51227 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751651Ab0K2Pci (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 10:32:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=IwNUEkn2EVxXBhH9H5No1ScmPiFptAkWGtPnUBK/KKLHKkUU3K1xf570HgEx9Oz84G
         bfMV5tGwcIHetecfOz/KgdJHSwOutgY+fvp+3cvRLMoPsnSe4x0trn3B+cPoiZmcARsh
         vSgLEkTye5gy0vlrswtu6ZSXXTeWIn+oFnZAc=
Date: Mon, 29 Nov 2010 18:32:32 +0300
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Lin Mac <mkl0301@gmail.com>
Cc: Greg KH <gregkh@suse.de>, Alan Stern <stern@rowland.harvard.edu>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        dbrownell@users.sourceforge.net, linux-usb@vger.kernel.org
Subject: Re: [PATCH v3 1/1] USB: cns3xxx: Add EHCI and OHCI bus glue for
 cns3xxx SOCs
Message-ID: <20101129153232.GA5161@oksana.dev.rtsoft.ru>
References: <20101125171541.GA18152@suse.de>
 <Pine.LNX.4.44L0.1011251521310.26094-100000@netrider.rowland.org>
 <20101126151131.GA26602@oksana.dev.rtsoft.ru>
 <20101126170348.GA3331@suse.de>
 <20101126182328.GA20923@oksana.dev.rtsoft.ru>
 <AANLkTinocHZBS4O7A2vhc-p6qX0wt04EfAi5Q2xgxSJW@mail.gmail.com>
 <AANLkTik7tZen0R51tvjhGamp_e9ue_Xh09S-EGsoWPUT@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <AANLkTik7tZen0R51tvjhGamp_e9ue_Xh09S-EGsoWPUT@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 29, 2010 at 11:58:15AM +0800, Lin Mac wrote:
[...]
> > +        * Set USB AHB INCR length to 16
> > +        */
> > +       if (atomic_inc_return(&usb_pwr_ref) == 0) {
> There's a typo here, the 0 should be 1 instead.

That was it. It works now.

[...]
> Should I resend the patch?

No need to, I've fixed the original commit.

Thanks!

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
