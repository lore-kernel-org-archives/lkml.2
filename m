Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757374Ab1EUWfc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 May 2011 18:35:32 -0400
Received: from he.sipsolutions.net ([78.46.109.217]:40211 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757343Ab1EUWfa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 May 2011 18:35:30 -0400
Subject: Re: [RFC] lib: crc8: add new library module providing crc8
 algorithm
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend@broadcom.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org,
        "John W. Linville" <linville@tuxdriver.com>,
        Dan Carpenter <error27@gmail.com>
In-Reply-To: <1306010973-5625-1-git-send-email-arend@broadcom.com> (sfid-20110521_225033_074451_F0976112)
References: <1306010973-5625-1-git-send-email-arend@broadcom.com>
	 (sfid-20110521_225033_074451_F0976112)
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 21 May 2011 15:37:35 -0700
Message-ID: <1306017455.3389.0.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-05-21 at 22:49 +0200, Arend van Spriel wrote:

> +/**
> + * enum - CRC8 constants
> + *
> + * @CRC8_INIT_VALUE: Initial CRC8 checksum value
> + * @CRC8_GOOD_VALUE: Good final CRC8 checksum value
> + *
> + * Constants for the crc8() function. Refer to its
> + * documentation how to use these values.
> + */
> +enum CRC8 {
> +	CRC8_INIT_VALUE	= 0xff,
> +	CRC8_GOOD_VALUE	= 0x9f
> +};

These seem a little out of place, wouldn't that be specific to how the
algorithm is used?

johannes

