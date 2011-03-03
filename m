Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758009Ab1CCLcb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 06:32:31 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:55302 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754797Ab1CCLca (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 06:32:30 -0500
X-Authenticated: #41721828
X-Provags-ID: V01U2FsdGVkX186z/1xm9k69+LwYsnQDpphl7TzpJipnNBaih9H7q
	OhTveRFLvLp19o
Date: Thu, 3 Mar 2011 12:32:25 +0100
From: Jonathan =?utf-8?Q?Neusch=C3=A4fer?= <j.neuschaefer@gmx.net>
To: Jack Stone <jwjstone@fastmail.fm>
Cc: Jonathan =?utf-8?Q?Neusch=C3=A4fer?= <j.neuschaefer@gmx.net>,
        Greg Kroah-Hartman <gregkh@suse.de>, Al Cho <acho@novell.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] staging: keucr: use kernel byteorder functions
Message-ID: <20110303113225.GA1341@debian.debian>
References: <1299109694-28758-1-git-send-email-j.neuschaefer@gmx.net>
 <1299109694-28758-2-git-send-email-j.neuschaefer@gmx.net>
 <4D6F4A43.5050903@fastmail.fm>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4D6F4A43.5050903@fastmail.fm>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 03, 2011 at 07:58:59AM +0000, Jack Stone wrote:
> >  
> > -			us->MS_Lib.BytesPerSector = LittleEndianWORD(idi->wIDIbytesPerSector);
> > +			us->MS_Lib.BytesPerSector = be16_to_cpu(idi->wIDIbytesPerSector);
> 
> Shouldn't this be le16_to_cpu?

Right. Thanks for pointing out.

Jonathan Neuschäfer
