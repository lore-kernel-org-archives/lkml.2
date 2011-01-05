Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751727Ab1AEQAq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 11:00:46 -0500
Received: from kroah.org ([198.145.64.141]:34876 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751026Ab1AEQAp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 11:00:45 -0500
Date: Wed, 5 Jan 2011 07:55:17 -0800
From: Greg KH <greg@kroah.com>
To: Jerome Marchand <jmarchan@redhat.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, Jens Axboe <jaxboe@fusionio.com>,
        Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] kref: add kref_test_and_get
Message-ID: <20110105155517.GA2072@kroah.com>
References: <4D07D2AC.6000500@fusionio.com>
 <4D0B68AF.80804@redhat.com>
 <4D0BB4A1.8080305@fusionio.com>
 <4D13664C.3020500@redhat.com>
 <20101223153915.GE9502@redhat.com>
 <4D13810B.8000304@redhat.com>
 <20101224192916.GB2082@redhat.com>
 <4D23423A.60707@redhat.com>
 <20110104205720.GA4180@kroah.com>
 <4D247388.9060302@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D247388.9060302@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 05, 2011 at 02:35:04PM +0100, Jerome Marchand wrote:
> On 01/04/2011 09:57 PM, Greg KH wrote:
> > On Tue, Jan 04, 2011 at 04:52:26PM +0100, Jerome Marchand wrote:
> >>
> >> Add kref_test_and_get() function, which atomically add a reference only if
> >> refcount is not zero. This prevent to add a reference to an object that is
> >> already being removed.
> > 
> > We just removed a function like this recently as it really isn't the
> > solution for what you need here at all.
> 
> What function are you talking about? kref_set? If yes, I don't see the
> similarity between this function and mine.

Sorry, yes, kref_set was recently removed.  I think this function was
added, and removed, even way before that.  Or at the least, it gets
proposed every few years and shot down as being incorrect.  This isn't
the first time :)

thanks,

greg k-h
