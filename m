Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933811Ab2C2UHH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 16:07:07 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:60235 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933798Ab2C2UG5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 16:06:57 -0400
Message-ID: <1333051616.15602.23.camel@joe2Laptop>
Subject: Re: [PATCH] percpu: use KERN_CONT in pcpu_dump_alloc_info()
From: Joe Perches <joe@perches.com>
To: Tejun Heo <tj@kernel.org>
Cc: Christoph Lameter <cl@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Kay Sievers <kay.sievers@vrfy.org>
Date: Thu, 29 Mar 2012 13:06:56 -0700
In-Reply-To: <CAOS58YOWA9U3Esb2535v_iivPaXeFYYS3nWd2KKF1=MsfZ0Piw@mail.gmail.com>
References: <20120329164842.GE28941@google.com>
	 <1333044612.15602.4.camel@joe2Laptop>
	 <CAOS58YOWA9U3Esb2535v_iivPaXeFYYS3nWd2KKF1=MsfZ0Piw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-03-29 at 12:51 -0700, Tejun Heo wrote:
> Hello, Joe.

Hello Tejun.

> On Thu, Mar 29, 2012 at 11:10 AM, Joe Perches <joe@perches.com> wrote:
> > Perhaps it's better to try to print lines
> > in fewer printks?  Maybe use a line buffer?
> What practical difference would that make?

It'd be just for avoidance of any other possible
interleaving from other threads.

It's an __init function so that's not too likely,
but if it every happens...

