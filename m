Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752259Ab0EHOcS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 May 2010 10:32:18 -0400
Received: from relay01.mx.bawue.net ([193.7.176.67]:48613 "EHLO
	relay01.mx.bawue.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751328Ab0EHOcR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 May 2010 10:32:17 -0400
Date: Sat, 8 May 2010 16:32:13 +0200
From: Nils Radtke <lkml@Think-Future.de>
To: linux-kernel@vger.kernel.org
Cc: "Jan Evert van Grootheest (SDG)" <j.e.van.grootheest@caiway.nl>,
       dri-devel@lists.freedesktop.org, Daniel Vetter <daniel@ffwll.ch>
Subject: Re: BUG: unable to handle kernel NULL pointer dereference,
 i915_gem_object_move_to_active
Message-ID: <20100508143213.GB30514@localhost>
Reply-To: Nils Radtke <lkml@Think-Future.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Url: http://www.Think-Future.de
X-Editor: Vi it! http://www.vim.org
X-Bkp: p2mi
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hi,

This might point to the same bug but seen from the process' perspective, it
then contains additional info about hw and kernel versions/circumstances:

  http://lkml.org/lkml/2010/2/18/104

This report might actually be related (in fact, same notebook):

  http://permalink.gmane.org/gmane.linux.kernel/981318

Daniel, I'm not sure I got what you intended to tell me w/:
> There's a test patch in that bz entry (the one that adds two BUG_ONs).
> If you're hitting these, is rather likely that it's the same bug.
bz entry?
I can't tell whether it's this exact bug. And I'm unfortunately a bit limited
in using the notebook to test and crash it, it's not mine and therefore not always 
there to play with, if you intended me to apply some patch and test whether the 
notebook will crash at the BUG_ON()s.

  Thanks,

  Nils

