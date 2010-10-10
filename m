Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932510Ab0JJNJq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Oct 2010 09:09:46 -0400
Received: from one.firstfloor.org ([213.235.205.2]:57340 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932390Ab0JJNJm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Oct 2010 09:09:42 -0400
Date: Sun, 10 Oct 2010 15:09:41 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Milan Broz <mbroz@redhat.com>
Cc: Andi Kleen <ak@linux.intel.com>,
        device-mapper development <dm-devel@redhat.com>,
        Mike Snitzer <msnitzer@redhat.com>, linux-kernel@vger.kernel.org,
        Andi Kleen <andi@firstfloor.org>, pedrib@gmail.com,
        Alasdair G Kergon <agk@redhat.com>
Subject: Re: [dm-devel] [PATCH] DM-CRYPT: Scale to multiple CPUs v3
Message-ID: <20101010130941.GF8256@basil.fritz.box>
References: <20101010115941.GA8539@basil.fritz.box>
 <4CB1B3B9.4030205@redhat.com>
 <4CB1B762.90900@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CB1B762.90900@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 10, 2010 at 02:53:54PM +0200, Milan Broz wrote:
> On 10/10/2010 02:38 PM, Milan Broz wrote:
> 
> > is there some change in your new version?
> Of course I mean except the changes you mentioned which are easy
> to change in my patchset:-)
> 
> (There was requirement from agk to have several simple
> bisectable patches.)

Well my patch is bisectable.

I don't see how it can be split up without being not functional
in the middle.

Either you have per cpu data or you don't.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
