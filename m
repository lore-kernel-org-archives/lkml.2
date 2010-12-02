Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756841Ab0LBCrN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 21:47:13 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:33700 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756480Ab0LBCrL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 21:47:11 -0500
Subject: Re: [PATCH] media: rc: ir-lirc-codec: fix potential integer overflow
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
From: Jarod Wilson <jarod@wilsonet.com>
In-Reply-To: <1290791197-21403-1-git-send-email-segoon@openwall.com>
Date: Wed, 1 Dec 2010 21:47:08 -0500
Cc: kernel-janitors@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        =?iso-8859-1?Q?David_H=E4rdeman?= <david@hardeman.nu>,
        Jarod Wilson <jarod@redhat.com>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <7965B2E6-E741-4FDB-84C4-8F5FD3A130A6@wilsonet.com>
References: <1290791197-21403-1-git-send-email-segoon@openwall.com>
To: Vasiliy Kulikov <segoon@openwall.com>
X-Mailer: Apple Mail (2.1082)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Nov 26, 2010, at 12:06 PM, Vasiliy Kulikov wrote:

> 'n' may be bigger than MAX_INT*sizeof(int), if so checking of truncated
> (int)(n/sizeof(int)) for LIRCBUF_SIZE overflow and then using nontruncated 'count'
> doesn't make sense.  Also n may be up to sizeof(int)-1 bytes bigger than expected,
> so check value of (n % sizeof(int)) too.
> 
> Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
> ---
> Compile tested only.

Looks sane.

Acked-by: Jarod Wilson <jarod@redhat.com>

-- 
Jarod Wilson
jarod@wilsonet.com



