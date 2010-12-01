Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754645Ab0LAHrn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 02:47:43 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:52460 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754232Ab0LAHq4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 02:46:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=bg1f3CuAixqNOL7i20WzDBsdbnVLbTbFrcNEmHTKpPnNYpa6i6FEkhXkrQoTJq+4aO
         EURjgXna/6YSIZlh0kbKpXow5BGW5IdHXHsxeYHzJApe4nTaBIiMsvC/MlSYwQd9NzIY
         1g+n+SCEIrXOliaJKZm0wVUFjJ9639CX4j84I=
Date: Tue, 30 Nov 2010 23:46:49 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: "Li, Yan I" <yan.i.li@intel.com>
Cc: Tobyn Bertram <tobynbertram@hotmail.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "'Takashi Iwai'" <tiwai@suse.de>,
        "Ding, Jian-feng" <jian-feng.ding@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "meego-kernel@lists.meego.com" <meego-kernel@lists.meego.com>
Subject: Re: [PATCH v2] Input: Bug 18122 - Support Lenovo S10-3t's 2-button
 ClickPad
Message-ID: <20101201074649.GC26958@core.coreip.homeip.net>
References: <aefc1833eeede37ae6ea4a9ddeaa602eb7d31101.1290823698.git.yan.i.li@intel.com>
 <ddb890ce98e91c7422da64168b1624c1e62a02ee.1291101955.git.yan.i.li@intel.com>
 <20101130075026.GA15731@core.coreip.homeip.net>
 <20101130080759.GA17830@thyme.bj.intel.com>
 <BAY130-DS5A81442DAC5CC69983A4ADE250@phx.gbl>
 <20101201041102.GC3411@thyme.bj.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101201041102.GC3411@thyme.bj.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 01, 2010 at 12:11:04PM +0800, Li, Yan I wrote:
> On Tue, Nov 30, 2010 at 11:48:12PM +0800, Tobyn Bertram wrote:
> > I do not have a S10-3t.  I have a HP DV7t with a standard 1 button Clickpad.
> > I am sorry for any confusion.
> 
> Thank you. This clarify the S10-3t touchpad mystery. So I think my v2
> patch is valid.
> 

Yep, I'll queue it gfor .37.

Thanks,

-- 
Dmitry
