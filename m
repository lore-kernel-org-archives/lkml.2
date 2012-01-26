Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753200Ab2AZQXY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 11:23:24 -0500
Received: from merlin.infradead.org ([205.233.59.134]:54820 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753034Ab2AZQXV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 11:23:21 -0500
Message-ID: <1327594989.2446.114.camel@twins>
Subject: Re: [RFCv3 0/9] perf tool: parser generator for events parsing
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Greg KH <greg@kroah.com>, acme@redhat.com, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, linux-kernel@vger.kernel.org
Date: Thu, 26 Jan 2012 17:23:09 +0100
In-Reply-To: <20120125143711.GD2582@m.brq.redhat.com>
References: <20120109152855.GA1597@m.brq.redhat.com>
	 <1326717103-10287-1-git-send-email-jolsa@redhat.com>
	 <1327422364.2446.75.camel@twins> <20120125005342.GA24662@kroah.com>
	 <1327488573.2614.59.camel@laptop> <20120125143711.GD2582@m.brq.redhat.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-01-25 at 15:37 +0100, Jiri Olsa wrote:
> please check attached patch, would something like this be ok?

Looks fine to me, Greg is that Documentation thing good enough
