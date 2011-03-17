Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752670Ab1CQAxZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 20:53:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1028 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752516Ab1CQAxT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 20:53:19 -0400
Date: Wed, 16 Mar 2011 20:53:05 -0400
From: Dave Jones <davej@redhat.com>
To: Greg KH <greg@kroah.com>
Cc: azurIt <azurit@pobox.sk>, linux-kernel@vger.kernel.org
Subject: Re: Regression from 2.6.36
Message-ID: <20110317005304.GA1992@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>, Greg KH <greg@kroah.com>,
	azurIt <azurit@pobox.sk>, linux-kernel@vger.kernel.org
References: <20110315132527.130FB80018F1@mail1005.cent>
 <20110317001519.GB18911@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110317001519.GB18911@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 16, 2011 at 05:15:19PM -0700, Greg Kroah-Hartman wrote:

 > > Do you need any other information from me ? I'm able to try other versions or
 > > patches but, please, take into account that I have to do this on _production_
 > > server (I failed to reproduce it in testing environment). Also, I'm able to try
 > > only one kernel per day.
 > 
 > Ick, one kernel per day might make this a bit difficult, but if there
 > was any way you could use 'git bisect' to try to narrow this down to the
 > patch that caused this problem, it would be great.
 > 
 > You can mark 2.6.35 as working and 2.6.36 as bad and git will go from
 > there and try to offer you different chances to find the problem.

Comparing the output of a perf profile between the good/bad kernels might
narrow it down faster than a bisect if something obvious sticks out.

	Dave

