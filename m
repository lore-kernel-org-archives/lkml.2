Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758940Ab2DZTsB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 15:48:01 -0400
Received: from usmamail.tilera.com ([206.83.70.75]:41350 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758622Ab2DZTr7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 15:47:59 -0400
Message-ID: <4F99A66C.4060008@tilera.com>
Date: Thu, 26 Apr 2012 15:47:56 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [EDAC_ABI PATCH v13 24/26] tile_edac: convert driver to use the
 new edac ABI
References: <1334607133-30039-1-git-send-email-mchehab@redhat.com> <1334607705-30320-1-git-send-email-mchehab@redhat.com> <1334607705-30320-25-git-send-email-mchehab@redhat.com>
In-Reply-To: <1334607705-30320-25-git-send-email-mchehab@redhat.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/16/2012 4:21 PM, Mauro Carvalho Chehab wrote:
> The legacy edac ABI is going to be removed. Port the driver to use
> and benefit from the new API functionality.
>
> Cc: Chris Metcalf <cmetcalf@tilera.com>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

For this and the other tile-related changes over the last couple of weeks:

Acked-by: Chris Metcalf <cmetcalf@tilera.com>

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

