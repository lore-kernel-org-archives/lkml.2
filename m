Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756803Ab1KVWN3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 17:13:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:62424 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752907Ab1KVWN2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 17:13:28 -0500
Date: Tue, 22 Nov 2011 17:13:21 -0500
From: Mike Snitzer <snitzer@redhat.com>
To: David Rientjes <rientjes@google.com>
Cc: Jens Axboe <axboe@kernel.dk>, Vivek Goyal <vgoyal@redhat.com>,
        Dave Young <dyoung@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, kexec@lists.infradead.org
Subject: Re: block: initialize request_queue's numa node during allocation
Message-ID: <20111122221320.GB17543@redhat.com>
References: <4ECB5C80.8080609@redhat.com>
 <alpine.DEB.2.00.1111220140470.4306@chino.kir.corp.google.com>
 <20111122152739.GA5663@redhat.com>
 <20111122211954.GA17120@redhat.com>
 <alpine.DEB.2.00.1111221342320.2621@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1111221342320.2621@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 22 2011 at  4:45pm -0500,
David Rientjes <rientjes@google.com> wrote:

> Also, your changelog is inadequate since it doesn't convey that his should 
> be merged for 3.2 because it fixes an oops when there is no node 0!

Also, this isn't new to 3.2, v2 should Cc: stable@kernel.org
