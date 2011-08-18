Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755130Ab1HRGqP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 02:46:15 -0400
Received: from emcscan.emc.com.tw ([192.72.220.5]:41244 "EHLO
	emcscan.emc.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751814Ab1HRGqN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 02:46:13 -0400
From: JJ Ding <jj_ding@emc.com.tw>
To: gaowanlong@cn.fujitsu.com
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Seth Forshee <seth.forshee@canonical.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Aaron Huang <aaron_huang@emc.com.tw>, Tom Lin <tom_lin@emc.com.tw>,
        Eric Piel <E.A.B.Piel@tudelft.nl>, Daniel Kurtz <djkurtz@chromium.org>,
        Chase Douglas <chase.douglas@canonical.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        Alessandro Rubini <rubini@cvml.unipv.it>
Subject: Re: [PATCH 4/6] Input: elantech - work around EC buffer
In-Reply-To: <4E4C81EB.7040303@cn.fujitsu.com>
References: <1313632629-23603-1-git-send-email-jj_ding@emc.com.tw> <1313632629-23603-5-git-send-email-jj_ding@emc.com.tw> <4E4C81EB.7040303@cn.fujitsu.com>
User-Agent: Notmuch/0.5 (http://notmuchmail.org) Emacs/23.2.1 (i686-pc-linux-gnu)
Date: Thu, 18 Aug 2011 14:48:34 +0800
Message-ID: <8739gz43lp.fsf@emc.com.tw>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wanlong Gao,

On Thu, 18 Aug 2011 11:07:23 +0800, Wanlong Gao <gaowanlong@cn.fujitsu.com> wrote:
> On 08/18/2011 09:57 AM, JJ Ding wrote:
> >
> >   	return PSMOUSE_FULL_PACKET;
> > +
> > + bad_packet:
> You may introduce space here.
Sorry, I am following you here.
Do you want me to add one more line below bad_packet:,
or you want me to remove the space before bad_packet?

I keep that space to make the goto tags look consistent with other
places in this file.

Should I remove all starting spaces in goto tags in the file?

Thanks,

jj

> > +	memmove(psmouse->packet, psmouse->packet + 1, psmouse->pktsize - 1);
> > +	psmouse->pktcnt--;
> > +	return PSMOUSE_GOOD_DATA;
> >   }
> >
> >   /*
> 
> 
> -- 
> Thanks
> Wanlong Gao
