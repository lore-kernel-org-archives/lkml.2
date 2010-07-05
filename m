Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755012Ab0GEUWa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jul 2010 16:22:30 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:33519 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753699Ab0GEUW2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jul 2010 16:22:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=O47Meuvj7tAQhNr1zqIkG3Lua0XXM0sc0ZqZAGM26AUSBCHy++0/ssIb+i3QQ5DoxY
         dfRTxs87wOBj7c7khxNbMpbuaTb83+na9pPG3c+32BzhZokrrWZR25FEPQDCym8Y1htk
         HEQzNjmpPz3GTLz6uLNXZAXkgybd9Gkajx07A=
Date: Mon, 5 Jul 2010 13:22:21 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: feng.tang@intel.com, linux-kernel@vger.kernel.org, tglx@linutronix.de,
       mingo@elte.hu, jacob.jun.pan@intel.com, randy.dunlap@oracle.com
Subject: Re: [PATCH v2 0/5] patches to settle i8042 with Intel MID platforms
Message-ID: <20100705202221.GA16978@core.coreip.homeip.net>
References: <1278342202-10973-1-git-send-email-feng.tang@intel.com>
 <4C32364D.2040705@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C32364D.2040705@zytor.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 05, 2010 at 12:45:17PM -0700, H. Peter Anvin wrote:
> On 07/05/2010 08:03 AM, feng.tang@intel.com wrote:
> > From: Feng Tang <feng.tang@intel.com>
> > 
> > Hi All,
> > 
> > Some x86 platforms like intel MID platforms don't have i8042 controllers,
> > and i8042 driver's probe to some non-exist legacy IO ports may hang
> > the MID processor. 
> > 
> > Current solution for this is add dependency of SERIO_I8042 over
> > !X86_MRST, then if we build a x86 kernel image with X86_MRST=y,
> > it won't have i8042 driver support over common x86 platforms.
> > 
> > So we add a i8042 pre-detect hook into x86_platforms ops, so that
> > i8042 driver can use it to run-time judge whether to go on with
> > probe process.
> > 
> > Please review these patches.
> > 
> 
> Looks good to me.  Dmitry, what do you think?
> 

Looks hood to me as well. We can either merge it through my tree or x86
tree, I don't have a preference.

-- 
Dmitry
