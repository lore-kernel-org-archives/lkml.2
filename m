Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754136Ab2DPTgH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 15:36:07 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:40914 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753859Ab2DPTgF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 15:36:05 -0400
Date: Mon, 16 Apr 2012 20:35:56 +0100
From: Luis Henriques <luis.henriques@canonical.com>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Matthew Garrett <mjg@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: amilo-rfkill: unsupported platform
Message-ID: <20120416193556.GD4047@zeus>
References: <20120416131216.GA4047@zeus>
 <1334583961.3209.112.camel@deadeye>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1334583961.3209.112.camel@deadeye>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 16, 2012 at 02:46:01PM +0100, Ben Hutchings wrote:
> On Mon, 2012-04-16 at 14:12 +0100, Luis Henriques wrote:
> > Hi Ben,
> > 
> > You have recently submitted a new rfkill driver for the Amilo A1655 and
> > M7440 models.  We have been using the fsam7400 driver[1] for the Amilo
> > M7440 and it would probably make sense to merge it into the amilo-rfkill.
> > 
> > However, the fsam7400 driver directly invokes BIOS code in order to turn
> > on/off the radio, instead of the methods used by the A1655 and M7440
> > driver.
> 
> Consistency, it's a wonderful thing.

Definitely it is, but a very rare thing.

> > This means the memory pages with the BIOS code would need to be
> > set as executable after the ioremap (which is probably a bad idea).
> > 
> > Are there any plans of merging this driver into the amilo-rfkill driver?
> 
> I have no plans for this, but feel free to try it.

Ok, thanks for the update.

Cheers,
--
Luis
