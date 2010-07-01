Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753480Ab0GADrJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 23:47:09 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:37811 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753278Ab0GADrH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 23:47:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=tOAT3ZShgrjOC9HIt1XP+IctpvOzZ57YhixvVu20uy7WWBONf1fKMsDJBXdAk4hQ+u
         Rm51ShTf/Q7IkvHRCgQlVyX6VX2OoR57YfyqImQnv6TSr7L3mAGoMcoI6gC7O94Eqs2h
         WqwgeeD6ATLz07qA9AJJtHr3DZ1JQyXTqdUv4=
Subject: Re: [PATCH] mtd/mxc_nand: remove unused variable
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: linux-mtd@lists.infradead.org, David Woodhouse <dwmw2@infradead.org>,
       Sascha Hauer <s.hauer@pengutronix.de>,
       Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
       Ivo Clarysse <ivo.clarysse@gmail.com>, linux-kernel@vger.kernel.org
In-Reply-To: <1276498911-28115-1-git-send-email-u.kleine-koenig@pengutronix.de>
References: <1276498911-28115-1-git-send-email-u.kleine-koenig@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 01 Jul 2010 06:47:01 +0300
Message-Id: <1277956021.3599.28.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-06-14 at 09:01 +0200, Uwe Kleine-König wrote:
> This fixes:
> 
> 	drivers/mtd/nand/mxc_nand.c: In function 'mxcnd_resume':
> 	drivers/mtd/nand/mxc_nand.c:901: warning: unused variable 'host'
> 
> Removing this variable was missed in 9c14b153e6af.
> 
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

Pushed to l2-mtd-2.6.git / master

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

