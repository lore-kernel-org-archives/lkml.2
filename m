Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752598Ab0GLX6G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 19:58:06 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:38294 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751868Ab0GLX6C convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 19:58:02 -0400
MIME-Version: 1.0
X-Originating-IP: [72.93.233.2]
In-Reply-To: <f607dad266e3d5c1b01aeb8420e09525f70cc1c0.1278967120.git.joe@perches.com>
References: <cover.1278967120.git.joe@perches.com>
	<f607dad266e3d5c1b01aeb8420e09525f70cc1c0.1278967120.git.joe@perches.com>
Date: Mon, 12 Jul 2010 19:58:01 -0400
Message-ID: <AANLkTikhq_nEYtUrmaV994TZoI0RdKfL6V-wx1e0eDGz@mail.gmail.com>
Subject: Re: [PATCH 11/36] drivers/media: Remove unnecessary casts of 
	private_data
From: Jarod Wilson <jarod@wilsonet.com>
To: Joe Perches <joe@perches.com>
Cc: Jiri Kosina <trivial@kernel.org>, linux-kernel@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Michael Hunold <michael@mihu.de>, Andy Walls <awalls@md.metrocast.net>,
        Laurent Pinchart <laurent.pinchart@skynet.be>,
        linux-media@vger.kernel.org, ivtv-devel@ivtvdriver.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 12, 2010 at 4:50 PM, Joe Perches <joe@perches.com> wrote:
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  drivers/media/IR/imon.c                    |    6 +++---

For the imon parts,

Acked-by: Jarod Wilson <jarod@redhat.com>


-- 
Jarod Wilson
jarod@wilsonet.com
