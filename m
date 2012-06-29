Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932083Ab2F2NXd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 09:23:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61449 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932068Ab2F2NXc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 09:23:32 -0400
Date: Fri, 29 Jun 2012 15:23:30 +0200
From: Petr Holasek <pholasek@redhat.com>
To: Cong Wang <xiyou.wangcong@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] KSM: numa awareness sysfs knob
Message-ID: <20120629132330.GA20670@dhcp-27-244.brq.redhat.com>
References: <1340970592-25001-1-git-send-email-pholasek@redhat.com>
 <jsk93p$32e$1@dough.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <jsk93p$32e$1@dough.gmane.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Jun 2012, Cong Wang wrote:
> On Fri, 29 Jun 2012 at 11:49 GMT, Petr Holasek <pholasek@redhat.com> wrote:
> > -		root_unstable_tree = RB_ROOT;
> > +		for (i = 0; i < MAX_NUMNODES; i++)
> > +			root_unstable_tree[i] = RB_ROOT;
> 
> 
> This is not aware of memory-hotplug, right?
> 

What makes you think so?
