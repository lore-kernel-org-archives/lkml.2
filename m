Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756265Ab0FETKf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jun 2010 15:10:35 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:40422 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752897Ab0FETKe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jun 2010 15:10:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=miOg9qpADtzIpU9I16li2hFoIz1FUJ43aen64V8d2ji40BKL/9kgnmssrivkEs6aBy
         yopt45knOkfGl49hZbUSgvGpdwdfaGsHIZ8stQE/O2yMZcsm48eJphwguypUHAx159iZ
         OIlSLZVBxJxZS5DnBDhOQk1yBPEuZ3Gv1X9wU=
Subject: Re: [linux-pm] [SUSPECTED SPAM] Re: Proposal for a new algorithm
 for	reading & writing a hibernation image.
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Nigel Cunningham <ncunningham@crca.org.au>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       TuxOnIce-devel <tuxonice-devel@tuxonice.net>
In-Reply-To: <201006052045.19889.rjw@sisk.pl>
References: <9rpccea67yy402c975fqru8r.1275576653521@email.android.com>
	 <4C099867.4050807@crca.org.au>  <201006052045.19889.rjw@sisk.pl>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 05 Jun 2010 22:10:21 +0300
Message-ID: <1275765021.12828.2.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-06-05 at 20:45 +0200, Rafael J. Wysocki wrote: 
> On Saturday 05 June 2010, Nigel Cunningham wrote:
> > Hi again.
> > 
> > As I think about this more, I reckon we could run into problems at 
> > resume time with reloading the image. Even if some bits aren't modified 
> > as we're writing the image, they still might need to be atomically 
> > restored. If we make the atomic restore part too small, we might not be 
> > able to do that.
> > 
> > So perhaps the best thing would be to stick with the way TuxOnIce splits 
> > the image at the moment (page cache / process pages vs 'rest'), but 
> > using this faulting mechanism to ensure we do get all the pages that are 
> > changed while writing the first part of the image.
> 
> I still don't quite understand why you insist on saving the page cache data
> upfront and re-using the memory occupied by them for another purpose.  If you
> dropped that requirement, I'd really have much less of a problem with the
> TuxOnIce's approach.
Because its the biggest advantage?
Really saving whole memory makes huge difference.


Best regards,
Maxim Levitsky

