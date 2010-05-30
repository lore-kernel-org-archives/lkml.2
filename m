Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754233Ab0E3UHn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 May 2010 16:07:43 -0400
Received: from mail-pz0-f204.google.com ([209.85.222.204]:40224 "EHLO
	mail-pz0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753742Ab0E3UHl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 May 2010 16:07:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=rD9BFPW07VsyTe54O77g8VFJdu2bK6rvAaAzR49YuucaKtz3uZl3mVaP3WzVZts2cW
         k12RFjmyBFQkpY4dXaqTfWRJHDnlLIcI4pH7SYbLCgoI2s6Nh1c7O3DL8zgFbsh9qW8E
         O3HimAEZDBUeTkQKId13VmRYD0tBuA5WCyJ0w=
Date: Sun, 30 May 2010 13:07:56 -0700
From: mark gross <640e9920@gmail.com>
To: Nigel Cunningham <ncunningham@crca.org.au>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, markgross@thegnar.org,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [linux-pm] [patch] complain when users abuse the pm_qos API
Message-ID: <20100530200756.GA25545@gvim.org>
Reply-To: markgross@thegnar.org
References: <20100529045027.GE11600@gvim.org>
 <201005292208.04309.rjw@sisk.pl>
 <4C019D36.8070405@crca.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C019D36.8070405@crca.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 30, 2010 at 09:03:18AM +1000, Nigel Cunningham wrote:
> Hi.
> 
> On 30/05/10 06:08, Rafael J. Wysocki wrote:
> >On Saturday 29 May 2010, mark gross wrote:
> >>The following patch is to help clean up API abusers of pm_qos where
> >>they call update_request before registering a request.
> >>
> >>--mgross
> >>
> >>--Signed-off-by: markgross<markgross@thegnar.org>
> >
> >Will there be a big issue if I push this during the next merge window?
> 
> What's the point to the patch? That is: why is calling
> update_request before registering a request such a big problem that
> it demands a WARN() and dump stack?

If e1000e realy needs the latency set and makes assumptions that its
done its part, I would like to let them know that they have not
registerd the request they thought they did.

--mgross

> 
> Regards,
> 
> Nigel
