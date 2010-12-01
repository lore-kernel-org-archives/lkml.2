Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752710Ab0LAHXN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 02:23:13 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:62876 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751260Ab0LAHXM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 02:23:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=bIg9/cHf43O0oKVrSw3CCMijUvhRYVr6KOoFhNVdvfaZlroTLWkkrgnbPoHtnQCYjQ
         47IH8YI+S61+ZxqW82lxsRjLt02rxFOrO5pNstET9BeubyNzxVnR3CMA9fCJYy8Ea5BE
         33Ar0YuVF0rWP88HUwS1yLMLY1oKj8333o0zA=
Date: Tue, 30 Nov 2010 23:23:04 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: "Li, Yan I" <yan.i.li@intel.com>
Cc: Tobyn Bertram <tobynbertram@hotmail.com>, "tiwai@suse.de" <tiwai@suse.de>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "Ding, Jian-feng" <jian-feng.ding@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "meego-kernel@lists.meego.com" <meego-kernel@lists.meego.com>
Subject: Re: [PATCH v2] Input: Bug 18122 - Support Lenovo S10-3t's 2-button
 ClickPad
Message-ID: <20101201072303.GB26958@core.coreip.homeip.net>
References: <aefc1833eeede37ae6ea4a9ddeaa602eb7d31101.1290823698.git.yan.i.li@intel.com>
 <ddb890ce98e91c7422da64168b1624c1e62a02ee.1291101955.git.yan.i.li@intel.com>
 <20101130075026.GA15731@core.coreip.homeip.net>
 <20101130080759.GA17830@thyme.bj.intel.com>
 <BAY130-DS5A81442DAC5CC69983A4ADE250@phx.gbl>
 <20101201041102.GC3411@thyme.bj.intel.com>
 <s5heia2ni58.wl%tiwai@suse.de>
 <BAY130-W15C8BF6B2994FAE083FAF5DE260@phx.gbl>
 <20101201071817.GB3874@thyme.bj.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101201071817.GB3874@thyme.bj.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 01, 2010 at 03:18:19PM +0800, Li, Yan I wrote:
> On Wed, Dec 01, 2010 at 02:41:14PM +0800, Tobyn Bertram wrote:
> > The 2-button Clickpad will probably need some code to handle click and drag properly in multi-touch mode.
> 
> Talk to a kernel developer and s/he will tell you to implement that
> logic in X. :)
> 

You knew, you knew ;)

-- 
Dmitry
