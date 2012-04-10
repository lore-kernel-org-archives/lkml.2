Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758418Ab2DJSgc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 14:36:32 -0400
Received: from casper.infradead.org ([85.118.1.10]:53041 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753349Ab2DJSgb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 14:36:31 -0400
Message-ID: <4F847DAB.5030707@kernel.dk>
Date: Tue, 10 Apr 2012 20:36:27 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Mike Snitzer <snitzer@redhat.com>
CC: Vivek Goyal <vgoyal@redhat.com>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>,
        martin.petersen@oracle.com
Subject: Re: [RFC PATCH] block: Change default IO scheduler to deadline except
 SATA
References: <20120410133708.GE21801@redhat.com> <4F843C17.5050004@kernel.dk> <20120410142148.GG21801@redhat.com> <20120410151042.GH21801@redhat.com> <CAMM=eLf5qi_PL8vFh_b5V_nq_mxg0CN0asE8E9XYJn48J4mdPA@mail.gmail.com>
In-Reply-To: <CAMM=eLf5qi_PL8vFh_b5V_nq_mxg0CN0asE8E9XYJn48J4mdPA@mail.gmail.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-04-10 18:13, Mike Snitzer wrote:
> That said, we can have a _very_ good hint that a SCSI device is a raid array if:
> 
> 1) optimal_io_size is not zero, minimum_io_size is not equal to
> optimal_io_size, and optimal_io_size is a multiple of minimum_io_size
> 
> 2) WCE=0 (higher-end arrays with a writeback cache)

Any other device than a basic SATA disk will have WCE=0. So I don't
think that gives you a very good hint of the nature of it,
unfortunately.

-- 
Jens Axboe

