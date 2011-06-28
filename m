Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758562Ab1F1PBG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 11:01:06 -0400
Received: from casper.infradead.org ([85.118.1.10]:44611 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758556Ab1F1PAi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 11:00:38 -0400
Subject: Re: power increase issue on light load
From: Peter Zijlstra <peterz@infradead.org>
To: "Alex,Shi" <alex.shi@intel.com>
Cc: "ncrao@google.com" <ncrao@google.com>, "mingo@elte.hu" <mingo@elte.hu>,
        "Chen, Tim C" <tim.c.chen@intel.com>,
        "Li, Shaohua" <shaohua.li@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        len.brown@intel.com
In-Reply-To: <1309219329.14604.11.camel@debian>
References: <1308797024.23204.95.camel@debian>
	 <1308819748.1022.69.camel@twins>  <1308876099.23204.124.camel@debian>
	 <1309219329.14604.11.camel@debian>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 28 Jun 2011 16:59:40 +0200
Message-ID: <1309273180.6701.213.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-06-28 at 08:02 +0800, Alex,Shi wrote:
> > > 
> > > What happens if you try something like the below. Increased imbalance
> > > might lead to more load-balance action, which might lead to more task
> > > migration/waking up of cpus etc.
> > > 
> > > If the below makes any difference, Nikhil's changes have a funny that
> > > needs to be caught.
> > 
> > Yes, it most remove the commit effect, So the power recovered. 
> > 
> > In fact the only suspicious I found is large imbalance, but that is
> > the commit want ...
> 
> Any further comments for this? 

I had a look over all that stuff, but I couldn't find an obvious unit
mis-match in any of the imbalance code. Nikhil any clue?
