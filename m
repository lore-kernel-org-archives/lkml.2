Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752889Ab0FLEuE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jun 2010 00:50:04 -0400
Received: from 1wt.eu ([62.212.114.60]:33154 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751895Ab0FLEuD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jun 2010 00:50:03 -0400
Date: Sat, 12 Jun 2010 06:49:51 +0200
From: Willy Tarreau <w@1wt.eu>
To: Henri =?iso-8859-1?Q?H=E4kkinen?= <henuxd@gmail.com>
Cc: gregkh@suse.de, peterhuewe@gmx.de, julia@diku.dk, sudhakar.raj@ti.com,
       devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging:panel: Fixed coding conventions.
Message-ID: <20100612044951.GB15336@1wt.eu>
References: <1276291656-2898-1-git-send-email-henuxd@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1276291656-2898-1-git-send-email-henuxd@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 12, 2010 at 12:27:36AM +0300, Henri Häkkinen wrote:
> Fixed coding convention issues as reported by checkpatch.pl tool
> on the file `panel.c'. Moved LCD special code handling from the
> function `lcd_write' into function `handle_lcd_special_code'. Also
> moved the handling of INPUT_ST_HIGH and INPUT_ST_FALLING states from
> the function `panel_process_input' into functions `input_state_high'
> and `input_state_falling'.
> 
> Signed-off-by: Henri Häkkinen <henuxd@gmail.com>

Acked-by: Willy Tarreau <w@1wt.eu>

Thank you Henri, this version is *a lot* better than previous one,
and the result is overall cleaner than the original.

Regards,
Willy

