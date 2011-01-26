Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753705Ab1AZRpB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 12:45:01 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:45045 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753435Ab1AZRpA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 12:45:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=OTZDIapAuvRn6F6uaQIFylGaadH7MrpvLV/aozwtj8f7Hxf1m4+K+xxLw5VfjoDb8e
         X5Ye3AvBl15b/+s5lz8cmMyXhW5PITT4H5zkZIokFyGnMeYFiGGbR3Fa7LTRXKxLVcOC
         iuARgogaZwtPGHUFYd9o+lijOmjHet+mNJ/wo=
MIME-Version: 1.0
In-Reply-To: <20110126172743.GI8446@linux.vnet.ibm.com>
References: <20110126172148.GB8446@linux.vnet.ibm.com>
	<20110126172743.GI8446@linux.vnet.ibm.com>
Date: Wed, 26 Jan 2011 19:44:59 +0200
X-Google-Sender-Auth: Hc_kVnYSoPIfR_zjEUUPSXL0aOs
Message-ID: <AANLkTinwJJ+SgstWEoKq7N0miz2zqMjj=TkLF-iqY123@mail.gmail.com>
Subject: Re: [PATCH 7/7] zram: mark the disk as non-rotating media
From: Pekka Enberg <penberg@kernel.org>
To: Nitin Gupta <ngupta@vflare.org>, Greg Kroah-Hartman <gregkh@suse.de>,
        Pekka Enberg <penberg@cs.helsinki.fi>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Cc: Robert Jennings <rcj@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 26, 2011 at 7:27 PM, Robert Jennings <rcj@linux.vnet.ibm.com> wrote:
> Adding QUEUE_FLAG_NONROT for the in the request_queue flags.  When used
> as a swap device, scan_swap_map will avoid the extra work of optimizing
> for rotating media.
>
> Signed-off-by: Robert Jennings <rcj@linux.vnet.ibm.com>

Reviewed-by: Pekka Enberg <penberg@kernel.org>
