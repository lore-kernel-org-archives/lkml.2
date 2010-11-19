Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757048Ab0KSVkP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 16:40:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:12529 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755232Ab0KSVkN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 16:40:13 -0500
Date: Fri, 19 Nov 2010 16:39:43 -0500
From: Jarod Wilson <jarod@redhat.com>
To: Nicolas Kaiser <nikai@nikai.net>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/media: nuvoton: fix chip id probe v2
Message-ID: <20101119213943.GI5022@redhat.com>
References: <20101116211953.238012db@absol.kitzblitz>
 <20101116215408.GA17140@redhat.com>
 <4CE33527.8090800@infradead.org>
 <20101117113525.1ded029c@absol.kitzblitz>
 <20101119191644.GF5022@redhat.com>
 <20101119214240.6b87dad7@absol.kitzblitz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101119214240.6b87dad7@absol.kitzblitz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 19, 2010 at 09:42:40PM +0100, Nicolas Kaiser wrote:
> Make sure we have a matching chip id high and one or the other
> of the chip id low values.
> Print the values if the probe fails.
> 
> Signed-off-by: Nicolas Kaiser <nikai@nikai.net>

That works for me, thanks much.

Acked-by: Jarod Wilson <jarod@redhat.com>

-- 
Jarod Wilson
jarod@redhat.com

