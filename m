Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758517Ab0LMR37 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 12:29:59 -0500
Received: from kroah.org ([198.145.64.141]:52296 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754090Ab0LMR36 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 12:29:58 -0500
Date: Mon, 13 Dec 2010 09:29:08 -0800
From: Greg KH <greg@kroah.com>
To: Avi Kivity <avi@redhat.com>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>, ak@linux.intel.com,
        mst@redhat.com, gregkh@suse.de, linux-kernel@vger.kernel.org,
        Andi Kleen <andi@firstfloor.org>, stable@kernel.org
Subject: Re: [stable] [PATCH] [104/223] KVM: Write protect memory after
 slot swap
Message-ID: <20101213172908.GA27614@kroah.com>
References: <20101212234644.B05DAB27BF@basil.firstfloor.org>
 <4D05DC98.40105@redhat.com>
 <044a861a2279c7e3e328c73e6694fbf3.squirrel@www.firstfloor.org>
 <4D05E096.6060307@redhat.com>
 <74ff92a8c4cf72e42e7559de72e77b52.squirrel@www.firstfloor.org>
 <4D05E2A5.8070204@redhat.com>
 <20101213091254.GA999@basil.fritz.box>
 <4D05E483.1000106@redhat.com>
 <AANLkTinOWHcyjXsY3Xhe6pxi3gyQ3tJMr2qCpRPuyBW4@mail.gmail.com>
 <4D0652FB.2090208@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D0652FB.2090208@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 13, 2010 at 07:08:11PM +0200, Avi Kivity wrote:
> Wait, there's a 34-lt too?
> 
> I'd like to have all stable kvms pass some minimum acceptance test,
> but that's quiet a lot of trees to maintain.  Why do we have to have
> both 34-lt and 35-lt?

Because people are crazy :)
