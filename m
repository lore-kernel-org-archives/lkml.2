Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753626Ab0ELGfS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 02:35:18 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59497 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752800Ab0ELGfP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 02:35:15 -0400
Subject: Re: [PATCH 0/9] pvclock misc fixes - v4.
Mime-Version: 1.0 (Apple Message framework v1078)
Content-Type: text/plain; charset=us-ascii
From: Alexander Graf <agraf@suse.de>
In-Reply-To: <4BEA4BD4.6070207@redhat.com>
Date: Wed, 12 May 2010 08:35:13 +0200
Cc: Zachary Amsden <zamsden@redhat.com>, Glauber Costa <glommer@redhat.com>,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <9318FF3C-DD25-48E7-B705-0ADA818CA13A@suse.de>
References: <1273594667-17175-1-git-send-email-glommer@redhat.com> <4BEA21A1.8040702@redhat.com> <AFD76714-2559-4281-AB61-EA5C6395C13A@suse.de> <4BEA4BD4.6070207@redhat.com>
To: Avi Kivity <avi@redhat.com>
X-Mailer: Apple Mail (2.1078)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 12.05.2010, at 08:33, Avi Kivity wrote:

> On 05/12/2010 08:47 AM, Alexander Graf wrote:
>> How about stable queuing of this one?
>> 
> 
> Only after this gets some serious field testing.  I'm not happy to trade a known issue for an unknown regression.  While I don't expect any problems with the patchset, testing has often proven me wrong.

Agreed. I merely wanted to raise awareness of me wanting to see this in -stable when it is stable :).


Alex

