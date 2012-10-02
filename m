Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754166Ab2JBOcR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 10:32:17 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:65070 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753686Ab2JBOcQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 10:32:16 -0400
Subject: RE: How to schedule worker and threaded IRQ on same cpu/core
From: anish kumar <anish198519851985@gmail.com>
To: "Pallala, Ramakrishna" <ramakrishna.pallala@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <D854C92F57B1B347B57E531E78D05EAD2A1EE5@BGSMSX102.gar.corp.intel.com>
References: <D854C92F57B1B347B57E531E78D05EAD2A1E0A@BGSMSX102.gar.corp.intel.com>
	 <1349181465.1440.1.camel@anish-Inspiron-N5050>
	 <D854C92F57B1B347B57E531E78D05EAD2A1EE5@BGSMSX102.gar.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 02 Oct 2012 20:02:06 +0530
Message-ID: <1349188326.1440.22.camel@anish-Inspiron-N5050>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-10-02 at 12:54 +0000, Pallala, Ramakrishna wrote:
> > > How can I schedule driver's worker and threaded IRQ on the same core?
> > >
> > > For work queue we have schedule_delayed_work_on () API available.
> > > But how to schedule the threaded IRQ on the same core where my worker
> > thread is going to run?
> > Why do you need to worry about where your worker thread is going to run?
> > Or IOW what use case do you have in mind?
> 
> In my driver I can get two independent events(IRQ and kernel notification). One will be handled by
> Threaded IRQ and other will be handled by a worker and the order is not guaranteed and with two cores
> Sometimes both workers are being scheduled  parallel.
So what is the problem even if they run in parallel, it would
be really help if we know what problem you are trying to solve?
Even if you want to sync between these two then you can have some
synchronisation mechanism between the two.
What is the advantage you are going to get if they run on same core?

Sorry but these answers would really help community in resolving your
problem.
> 
> The events I get from two sources are related so I wanted to run my workers and threaded IRQ on single(same) core/cpu.
> 
> Thanks,
> Ram
>  
> 


