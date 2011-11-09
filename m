Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933109Ab1KIVA6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 16:00:58 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:53995 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932781Ab1KIVA5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 16:00:57 -0500
Date: Wed, 9 Nov 2011 22:00:52 +0100
From: Borislav Petkov <bp@amd64.org>
To: Tony Luck <tony.luck@gmail.com>
Cc: Niklas =?iso-8859-1?Q?S=F6derlund?= 
	<niklas.soderlund@ericsson.com>,
        "dougthompson@xmission.com" <dougthompson@xmission.com>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] amd64_edac: fix size decoding error on K8
Message-ID: <20111109210052.GJ14181@aftab>
References: <1320849178-23340-1-git-send-email-niklas.soderlund@ericsson.com>
 <20111109144258.GD30472@aftab>
 <4EBA98A1.90902@ericsson.com>
 <20111109203546.GI14181@aftab>
 <CA+8MBbLuhhTZW9vB7GvLCd8Uu7bgfUqkO7wu4=Pt7EWyQx0LrQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+8MBbLuhhTZW9vB7GvLCd8Uu7bgfUqkO7wu4=Pt7EWyQx0LrQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 09, 2011 at 12:50:42PM -0800, Tony Luck wrote:
> On Wed, Nov 9, 2011 at 12:35 PM, Borislav Petkov <bp@amd64.org> wrote:
> > +               diff = cs_mode / 3 + (unsigned)(cs_mode > 5);
> > +
> > +               return 32 << (cs_mode - diff);
> 
> Code is correct - but looks like an entry for an obfuscated C
> competition.

I know, right?! Especially casting the boolean to an unsigned int. Yuck!
But it is compact the stupid thing.

> Perhaps it deserves a comment!

Sure it does, will do.

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
