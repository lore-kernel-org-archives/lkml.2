Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753252Ab0CUDZa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Mar 2010 23:25:30 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:44276 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752998Ab0CUDZ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Mar 2010 23:25:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=ZIsSoaTwVWhm0VclGo4BT90oHOlO3yfcZ580N5QPYb/4v2pkylVWV4Sv2YZ+h5ehb3
         wj37VdLkIgNdTkW1kcIs3NjNMlESUKv1FwzA2wKNk6REhNE6ch4i3NtzsfPMufNcvN4H
         ivYJdR0+Qjia7AnchHDlKKBDtOMNzN0aB4ldw=
Date: Sat, 20 Mar 2010 20:25:22 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Bruno =?iso-8859-1?Q?Pr=E9mont?= <bonbons@linux-vserver.org>
Cc: Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
       linux-usb@vger.kernel.org, linux-fbdev@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       "Rick L. Vinyard Jr." <rvinyard@cs.nmsu.edu>,
       Nicu Pavel <npavel@ituner.com>, Oliver Neukum <oliver@neukum.org>,
       Jaya Kumar <jayakumar.lkml@gmail.com>
Subject: Re: [PATCH v2 2/6] hid: add framebuffer support to PicoLCD device
Message-ID: <20100321032522.GD29360@core.coreip.homeip.net>
References: <20100320170014.440959a8@neptune.home>
 <20100320170415.6ee219c8@neptune.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100320170415.6ee219c8@neptune.home>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 20, 2010 at 05:04:15PM +0100, Bruno Prémont wrote:
> +static inline int picolcd_fb_send_tile(struct hid_device *hdev, int chip,
> +		int tile)
> +{

You seemt o be fond of the 'inline; attribute ;) I don't think that a
40 lines function qualifies. Please lose inlines on functions that are
not in .h files and are not stubs.

-- 
Dmitry
