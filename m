Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752200Ab1AEQBe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 11:01:34 -0500
Received: from kroah.org ([198.145.64.141]:34884 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751322Ab1AEQAp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 11:00:45 -0500
Date: Wed, 5 Jan 2011 07:56:19 -0800
From: Greg KH <greg@kroah.com>
To: Jerome Marchand <jmarchan@redhat.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, Vivek Goyal <vgoyal@redhat.com>,
        Jens Axboe <jaxboe@fusionio.com>,
        Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2 v2] kref: add kref_test_and_get
Message-ID: <20110105155619.GB2072@kroah.com>
References: <4D07D2AC.6000500@fusionio.com>
 <4D0B68AF.80804@redhat.com>
 <4D0BB4A1.8080305@fusionio.com>
 <4D13664C.3020500@redhat.com>
 <20101223153915.GE9502@redhat.com>
 <4D13810B.8000304@redhat.com>
 <20101224192916.GB2082@redhat.com>
 <4D23423A.60707@redhat.com>
 <1294157114.3579.102.camel@edumazet-laptop>
 <4D2487F9.8030704@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D2487F9.8030704@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 05, 2011 at 04:02:17PM +0100, Jerome Marchand wrote:
> 
> Add kref_test_and_get() function, which atomically add a reference only if
> refcount is not zero. This prevent to add a reference to an object that is
> already being removed.

Again, no, I do not like this and will not accept this, sorry.

Please read the kref documentation for how to properly handle this,
without this function.

greg k-h
