Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945999Ab2JaSWl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 14:22:41 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:33369 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423220Ab2JaSWj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 14:22:39 -0400
Date: Wed, 31 Oct 2012 11:22:06 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Jonathan Nieder <jrnieder@gmail.com>
Cc: =?utf-8?B?UGF3ZcWC?= Sikora <pawel.sikora@agmk.net>,
        skinsbursky@parallels.com, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, baggins@pld-linux.org,
        arekm@pld-linux.org
Subject: Re: [PATCH] lockd: fix races in per-net NSM client handling
Message-ID: <20121031182206.GB1542@kroah.com>
References: <1689813.hptKgzjpAu@localhost>
 <20121031174946.GA13591@kroah.com>
 <20121031180550.GD30432@elie.Belkin>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20121031180550.GD30432@elie.Belkin>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 31, 2012 at 11:05:51AM -0700, Jonathan Nieder wrote:
> Hi,
> 
> Greg KH wrote:
> > On Wed, Oct 31, 2012 at 06:27:36PM +0100, Paweł Sikora wrote:
> 
> >> the patch metioned in https://lkml.org/lkml/2012/10/24/175 seems to fix
> >> the 3.6.3 oops (while 3.6.2 works fine) at 16-cores opteron server.
> >> please queue this path for 3.6.$next.
> >
> > Is it in Linus's tree already?  If so, what is the git commit id?
> 
> One of
> 
>   a4ee8d978e47 LOCKD: fix races in nsm_client_get
>   e498daa81295 LOCKD: Clear ln->nsm_clnt only when ln->nsm_users is zero
> 
> both of which were included in v3.6.5.

Ok, Paweł, does 3.6.5 work properly for you?

thanks,

greg k-h
