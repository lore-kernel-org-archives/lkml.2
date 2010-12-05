Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754692Ab0LEVaH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Dec 2010 16:30:07 -0500
Received: from lo.gmane.org ([80.91.229.12]:42074 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751713Ab0LEVaG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Dec 2010 16:30:06 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Sriram <sri.kmb@gmail.com>
Subject: Re: =?utf-8?b?W2RybTppbml0X3JpbmdfY29tbW9uXQ==?= *ERROR* render ring head not reset to zero
Date: Sun, 5 Dec 2010 06:28:25 +0000 (UTC)
Message-ID: <loom.20101205T072655-971@post.gmane.org>
References: <201010042231.20320.thomas@m3y3r.de> <8u3s8d$jp78ts@orsmga001.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: sea.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 117.206.71.100 (Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.10) Gecko/20101005 Fedora/3.6.10-1.fc14 Firefox/3.6.10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Wilson <chris <at> chris-wilson.co.uk> writes:

> 
> On Mon, 4 Oct 2010 22:31:20 +0200, Thomas Meyer <thomas <at> m3y3r.de> wrote:
> > [    0.556247] [drm:init_ring_common] *ERROR* render ring head not reset to
zero ctl 00000000 head
> 02001000 tail 00000000 start 02001000
> > [    0.556320] [drm:init_ring_common] *ERROR* render ring head forced to
zero ctl 00000000 head 00000000
> tail 00000000 start 02001000
> > 
> > Bug or feature?
> 
> Hardware feature, software bug. Could also be a feature of the software to
> report a hardware bug...
> 
> At any rate, it shouldn't be happening and you are not alone at finding
> such errors in your logs.
> -Chris
> 


Hi Chris,

Please explain what this error means & why it is happening...

