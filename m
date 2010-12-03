Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932522Ab0LCMOJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 07:14:09 -0500
Received: from casper.infradead.org ([85.118.1.10]:54596 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932435Ab0LCMOI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 07:14:08 -0500
Message-ID: <4CF8DF08.1000002@infradead.org>
Date: Fri, 03 Dec 2010 10:14:00 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100827 Red Hat/3.1.3-1.el6 Lightning/1.0b2 Thunderbird/3.1.3
MIME-Version: 1.0
To: manjunatha_halli@ti.com
CC: hverkuil@xs4all.nl, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org
Subject: Re: [RFC v6 2/9] Documentation:DocBook:v4l: Update the controls.xml
 for TI FM driver
References: <1291380631-25993-1-git-send-email-manjunatha_halli@ti.com> <1291380631-25993-2-git-send-email-manjunatha_halli@ti.com> <1291380631-25993-3-git-send-email-manjunatha_halli@ti.com>
In-Reply-To: <1291380631-25993-3-git-send-email-manjunatha_halli@ti.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 03-12-2010 10:50, manjunatha_halli@ti.com escreveu:
> From: Manjunatha Halli <manjunatha_halli@ti.com>
> 
> Added entries for following 2 new CID's which are added for TI FM
> driver:
> - V4L2_CID_RSSI_THRESHOLD
> - V4L2_CID_TUNE_AF
> 
> Signed-off-by: Manjunatha Halli <manjunatha_halli@ti.com>
> ---
>  Documentation/DocBook/v4l/controls.xml |   12 ++++++++++++
>  1 files changed, 12 insertions(+), 0 deletions(-)
> 
> diff --git a/Documentation/DocBook/v4l/controls.xml b/Documentation/DocBook/v4l/controls.xml
> index 2fae3e8..b560953 100644
> --- a/Documentation/DocBook/v4l/controls.xml
> +++ b/Documentation/DocBook/v4l/controls.xml
> @@ -132,6 +132,18 @@ consumption state.</entry>
>  	    <entry>Loudness mode (bass boost).</entry>
>  	  </row>
>  	  <row>
> +           <entry><constant>V4L2_CID_RSSI_THRESHOLD</constant></entry>
> +           <entry>integer</entry>
> +           <entry>Set RSSI threshold level. Change the default threshold
> +level used to select valid frequencies during vidioc_s_hw_freq_seek.</entry>
> +         </row>
> +         <row>
> +           <entry><constant>V4L2_CID_TUNE_AF</constant></entry>
> +           <entry>integer</entry>
> +           <entry>Set Alternative Frequency mode. Enable or disable
> +alternative frequency mode.</entry>
> +         </row>
> +         <row>
>  	    <entry><constant>V4L2_CID_BLACK_LEVEL</constant></entry>
>  	    <entry>integer</entry>
>  	    <entry>Another name for brightness (not a synonym of

Sorry, but, I doubt that any userspace application developer will find those descriptions
useful. 

For the threshold: I understand that this is the carrier strength used to detect a
channel, right? If so, please improve the description.
Also, The better is to associate its scale to a carrier level in some unit like dB.

The second control means absolutely nothing... It is not a boolean value, and what
is "alternative" frequency mode?

Cheers,
Mauro.

